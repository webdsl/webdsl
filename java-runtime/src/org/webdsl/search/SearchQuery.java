package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.QueryParser;
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
	protected boolean luceneQueryChanged = true;
	protected boolean isNGramFieldBoosted = false;
	protected Query luceneQuery = null;
	protected HashMap<String, String> constraints = new HashMap<String, String>();
	protected FullTextQuery query = null;
	protected FacetManager facetManager = null;
	protected String searchTerms = "";
	protected HashMap<String,Float> boosts = new HashMap<String, Float>();

	protected String[] nGramFilterFields;
	protected String[] untokenizedFields;

	// In case of a field with n-gram filter, the MultiFieldQueryParser adds double quotes around the search tokens (ngrams)
	// These need to be removed to work properly.
	protected String[] nonNGramSearchFields;
	protected String[] nGramSearchFields;
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
		
		for(int i=0; i<nGramSearchFields.length && !isNGramFieldBoosted; isNGramFieldBoosted = field.equals(nGramSearchFields[i++])){}

		boosts.put(field, boost);
		luceneQueryChanged = true;
		return (F) this;
	}
	
	private void enableFieldConstraintFilter(String field, String value) {
		query.enableFullTextFilter("fieldConstraintFilter").setParameter("field", field).setParameter("value", value);
	}
	
	//Currently not working correctly on embedded collections see: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-726
	public List<Facet> facets(String field, int topN) {	
		org.hibernate.search.query.dsl.QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
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
	public <F extends SearchQuery<EntityClass>> F fields(List<String> fields) {
		List<String> selectedNGramFields = new ArrayList<String>();
		
		//N-gram fields need special treatment during querying, using QueryBuilder instead of MultiFieldQueryParser.
		for (int i = 0; i < nGramFilterFields.length; i++)
			if (fields.remove(nGramFilterFields[i]))
				selectedNGramFields.add(nGramFilterFields[i]);		
		nGramSearchFields = selectedNGramFields.toArray(new String[selectedNGramFields.size()]);
		nonNGramSearchFields = fields.toArray(new String[fields.size()]);
		
		//Untokenized fields should be excluded from more like this queries
		for (int i = 0; i < untokenizedFields.length; i++)
			fields.remove(untokenizedFields[i]);			
		mltSearchFields = fields.toArray(new String[fields.size()]);

		luceneQueryChanged = true;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F firstResult(int offset) {
		this.offset = offset;
		return (F) this;
	}

	private void fixQueryForNgramFilterFields() {
		QueryBuilder qb = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		
		if(!isNGramFieldBoosted)
			luceneQuery = luceneQuery.combine(new Query[] {luceneQuery, qb.keyword().onFields(nGramSearchFields).matching(searchTerms).createQuery() });
		else
			for(int i=0; i<nGramSearchFields.length; i++)
				if(boosts.containsKey(nGramSearchFields[i]))
					luceneQuery = luceneQuery.combine(new Query[] {luceneQuery,	qb.keyword().onField(nGramSearchFields[i]).boostedTo(boosts.get(nGramSearchFields[i])).matching(searchTerms).createQuery() });
				else
					luceneQuery = luceneQuery.combine(new Query[] {luceneQuery,	qb.keyword().onField(nGramSearchFields[i]).matching(searchTerms).createQuery() });		
	}

	private IndexReader getReader() {
		SearchFactory searchFactory = fullTextSession.getSearchFactory();
		DirectoryProvider<?> provider = searchFactory
				.getDirectoryProviders(entityClass)[0];
		ReaderProvider readerProvider = searchFactory.getReaderProvider();
		return readerProvider.openReader(provider);
	}

	@SuppressWarnings("unchecked")
	public List<EntityClass> list() {
		searchTime = 0;
		if (validateQuery()) {
			searchTime = System.currentTimeMillis();
			List<EntityClass> toReturn = query.list();
			searchTime = System.currentTimeMillis() - searchTime;
			return toReturn;
		} else
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
		mlt.setAnalyzer(fullTextSession.getSearchFactory().getAnalyzer(entityClass));
		mlt.setMinWordLen(minWordLen);
		mlt.setMaxWordLen(maxWordLen);
		mlt.setMaxDocFreqPct(maxDocFreqPct);
		mlt.setMinDocFreq(minDocFreq);
		mlt.setMinTermFreq(minTermFreq);
		mlt.setMaxQueryTerms(maxQueryTerms);
		
		try {
			luceneQuery = mlt.like(new StringReader(likeText));
			query = fullTextSession.createFullTextQuery(luceneQuery, entityClass);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(ir != null)
			fullTextSession.getSearchFactory().getReaderProvider().closeReader(ir);
		}
		
		luceneQueryChanged = false;

		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F narrowOnFacet(Facet facet) {

		String facetName = facet.getFieldName();
		query.getFacetManager().getFacetGroup(facetName).selectFacets(facet);

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
	
	public ArrayList<String> suggestTerms (String toSuggestOn, List<String> fields){

		searchTime = System.currentTimeMillis();
		SearchSuggester suggester = new SearchSuggester();
		ArrayList<String> toReturn = (ArrayList<String>) suggester.findSuggestions(fullTextSession.getSearchFactory(), this, 3, fields, toSuggestOn);
		searchTime = System.currentTimeMillis() - searchTime;
		
		return toReturn;		
	}

	public String terms(){
			return this.searchTerms;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F terms(String terms) {
		searchTerms = terms;
		luceneQueryChanged = true;
		return (F) this;
	}

	private boolean validateQuery() {
		if (luceneQueryChanged) {
			if(!createMultiFieldQuery())
				return false;
			applyFieldConstraints();
			luceneQueryChanged = false;

		}
		query.setFirstResult(offset);
		query.setMaxResults(limit);

		return true;
	}
	
	private boolean createMultiFieldQuery(){
		if (!searchTerms.isEmpty()) {
			
			QueryParser parser;
			
			if(boosts.isEmpty()) {
				parser = new MultiFieldQueryParser(	luceneVersion, nonNGramSearchFields, fullTextSession.getSearchFactory().getAnalyzer(entityClass));
			} else {
				parser = new MultiFieldQueryParser(	luceneVersion, nonNGramSearchFields, fullTextSession.getSearchFactory().getAnalyzer(entityClass), boosts);
			}
			
			try {
				luceneQuery = parser.parse(searchTerms);
				if (nGramSearchFields.length > 0)
					fixQueryForNgramFilterFields();
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
		query = fullTextSession.createFullTextQuery(luceneQuery, entityClass);
		return true;
	}
	
	public abstract Directory spellDirectoryForField(String field);
}