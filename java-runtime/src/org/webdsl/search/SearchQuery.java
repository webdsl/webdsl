package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.queryParser.QueryParser.Operator;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.similar.MoreLikeThis;
import org.apache.lucene.store.Directory;
import org.apache.lucene.util.Version;
import org.hibernate.search.FullTextQuery;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.hibernate.search.query.engine.spi.FacetManager;
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetSortOrder;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.reader.ReaderProvider;
import org.hibernate.search.store.DirectoryProvider;
import org.webdsl.WebDSLEntity;

public abstract class SearchQuery<EntityClass extends WebDSLEntity> {

	protected final Version luceneVersion = Version.LUCENE_31;
	protected int limit = 100;
	protected int offset = 0;
	protected boolean luceneQueryChange = true;
	protected boolean fullTextQueryChange = true;
	protected boolean isNGramFieldBoosted = false;
	protected Query luceneQuery = null;
	protected HashMap<String, String> constraints = new HashMap<String, String>();
	protected FullTextQuery query = null;
	protected FacetManager facetManager = null;
	protected String searchTerms = "";
	protected HashMap<String,Float> boosts = new HashMap<String, Float>();
	protected Operator op = Operator.OR; 
	protected Analyzer analyzer;

	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;

	protected FullTextSession fullTextSession;
	protected Class<?> entityClass;
	protected long searchTime = 0;

	public SearchQuery() {
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F addFieldConstraint(String fieldname, String terms) {
		
		if (validateQuery())
			enableFieldConstraintFilter(fieldname, terms);
		
		constraints.put(fieldname, terms);		
		return (F) this;
	}

	private void applyFieldConstraints() {
		for (String field : constraints.keySet())
			enableFieldConstraintFilter(field, constraints.get(field));
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F boost(String field, Float boost) {
		if (boosts.containsKey(field))
			boosts.remove(field);
		
		boosts.put(field, boost);
		luceneQueryChange = true;
		return (F) this;
	}
	
	private void enableFieldConstraintFilter(String field, String value) {
		query.enableFullTextFilter("fieldConstraintFilter").setParameter("field", field).setParameter("value", value);
	}
	
	//Currently not working correctly on embedded collections see: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-726
	public List<Facet> facets(String field, int topN) {	
		QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		FacetingRequest facetReq = builder
			.facet()
			.name("facet_" + field)
			.onField(field)
			.discrete().orderedBy(FacetSortOrder.COUNT_DESC)
			.includeZeroCounts(false).maxFacetCount(topN)
			.createFacetingRequest();

		if (validateQuery())
			return query.getFacetManager().enableFaceting(facetReq).getFacets("facet_" + field);
		else
			return new ArrayList<Facet>();
	}
	
	@SuppressWarnings("unchecked")
	private <F extends SearchQuery<EntityClass>> F setRangeQuery(Object from, Object to) {
		QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		luceneQuery = builder.range().onField(searchFields[0]).from(from).to(to).excludeLimit().createQuery();
		luceneQueryChange = false;
		fullTextQueryChange = true;
		return (F) this;
	}
	
	public <F extends SearchQuery<EntityClass>> F range(Date from, Date to) {
		return setRangeQuery(from,to);
	}
	public <F extends SearchQuery<EntityClass>> F range(int from, int to) {
		return setRangeQuery(from,to);
	}
	public <F extends SearchQuery<EntityClass>> F range(Float from, Float to) {
		return setRangeQuery(from,to);
	}
	public <F extends SearchQuery<EntityClass>> F range(String from, String to) {
		return setRangeQuery(from,to);
	}
	
	public <F extends SearchQuery<EntityClass>> F field(String field){
		return fields(new ArrayList<String>(Arrays.asList(field) ));
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F fields(List<String> fields) {		
		searchFields = fields.toArray(new String[fields.size()]);
		
		//Untokenized fields should be excluded from more like this queries
		for (int i = 0; i < untokenizedFields.length; i++)
			fields.remove(untokenizedFields[i]);			
		mltSearchFields = fields.toArray(new String[fields.size()]);

		luceneQueryChange = true;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F firstResult(int offset) {
		this.offset = offset;
		return (F) this;
	}

	public IndexReader getReader() {
		SearchFactory searchFactory = fullTextSession.getSearchFactory();
		DirectoryProvider<?> provider = searchFactory
				.getDirectoryProviders(entityClass)[0];
		ReaderProvider readerProvider = searchFactory.getReaderProvider();
		return readerProvider.openReader(provider);
	}
	
	public void closeReader(IndexReader reader){
		if(reader != null)
		fullTextSession.getSearchFactory().getReaderProvider().closeReader(reader);
	}

	public String highlight(String field, String toHighLight){
		return ResultHighlighter.highlight(this, field, toHighLight);
	}
	
	@SuppressWarnings("unchecked")
	public List<EntityClass> list() {
		searchTime = System.currentTimeMillis();
		if (validateQuery()) {
			List<EntityClass> toReturn = query.list();
			searchTime = System.currentTimeMillis() - searchTime;
			return toReturn;
		} else
			searchTime = 0;
			return new ArrayList<EntityClass>();
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F maxResults(int limit) {
		this.limit = limit;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F moreLikeThis(String likeText) {
		int minWordLen = 5, maxWordLen = 30, minDocFreq = 1, minTermFreq = 3, maxQueryTerms = 6, maxDocFreqPct = 100;
		return (F) moreLikeThis(likeText, minWordLen, maxWordLen, minDocFreq, maxDocFreqPct,
				minTermFreq, maxQueryTerms);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F moreLikeThis(
			String likeText, int minWordLen, int maxWordLen, int minDocFreq, int maxDocFreqPct, int minTermFreq,	int maxQueryTerms) {
		IndexReader ir = getReader();
		MoreLikeThis mlt = new MoreLikeThis(ir);
		mlt.setFieldNames(mltSearchFields);
		mlt.setAnalyzer(analyzer);
		mlt.setMinWordLen(minWordLen);
		mlt.setMaxWordLen(maxWordLen);
		mlt.setMaxDocFreqPct(maxDocFreqPct);
		mlt.setMinDocFreq(minDocFreq);
		mlt.setMinTermFreq(minTermFreq);
		mlt.setMaxQueryTerms(maxQueryTerms);
		
		try {
			luceneQuery = mlt.like(new StringReader(likeText));
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			closeReader(ir);
		}
		luceneQueryChange = false;
		fullTextQueryChange = true;

		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F narrowOnFacet(Facet facet) {

		String facetName = facet.getFieldName();
		query.getFacetManager().getFacetGroup(facetName).selectFacets(facet);

		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultAnd() {
		if (!op.equals(Operator.AND)){	
			op = Operator.AND;
			luceneQueryChange = true;
		}
		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultOr() {
		if (!op.equals(Operator.OR)){	
			op = Operator.OR;
			luceneQueryChange = true;
		}		
		return (F) this;
	}

	public int resultSize() {
		if (validateQuery())
			return query.getResultSize();
		else
			return -1;
	}

	public String searchTimeAsString() {
		return searchTime + " ms.";
	}

	public int searchTimeMillis() {
		return (int) this.searchTime;
	}

	public float searchTimeSeconds() {
		return (float) (this.searchTime / 1000);
	}

	public ArrayList<String> suggest(String toSuggestOn, List<String> fields){
		searchTime = System.currentTimeMillis();
		ArrayList<String> toReturn = (ArrayList<String>) SearchSuggester.findSuggestions(this, 3, fields, toSuggestOn);
		searchTime = System.currentTimeMillis() - searchTime;
		
		return toReturn;
	}
	public String terms(){
			return this.searchTerms;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F terms(String terms) {
		searchTerms = terms;
		luceneQueryChange = true;
		return (F) this;
	}

	private boolean validateQuery() {
		if (luceneQueryChange) {
			if(!createMultiFieldQuery())
				return false;
			luceneQueryChange = false;
			fullTextQueryChange = true;

		}
		if(fullTextQueryChange){
			query = fullTextSession.createFullTextQuery(luceneQuery, entityClass);
			applyFieldConstraints();
			query.setFirstResult(offset);
			query.setMaxResults(limit);
			fullTextQueryChange = false;
		}

		return true;
	}
	
	private boolean createMultiFieldQuery(){
		if (!searchTerms.isEmpty()) {
			
			QueryParser parser;
			if(boosts.isEmpty()) {
				parser = new MultiFieldQueryParser(	luceneVersion, searchFields, analyzer);
			} else {
				parser = new MultiFieldQueryParser(	luceneVersion, searchFields, analyzer, boosts);
			}			
			parser.setDefaultOperator(op);
			try {
				luceneQuery = parser.parse(searchTerms);
			} catch (org.apache.lucene.queryParser.ParseException pe) {
				return false;
			}
		}
		// Match all documents if no search terms are given
		else {
			luceneQuery = fullTextSession.getSearchFactory()
					.buildQueryBuilder().forEntity(entityClass).get().all()
					.createQuery();
		}
		return true;
	}
	
	public abstract Directory spellDirectoryForField(String field);
}