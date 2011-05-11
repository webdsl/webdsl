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
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
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
	
	protected int limit = 50;
	protected int offset = 0;
	
	protected boolean updateLuceneQuery = true;
	protected boolean updateFullTextQuery = true;

	protected HashMap<String, String> constraints = new HashMap<String, String>();
	protected HashMap<String,Float> boosts = new HashMap<String, Float>();
	protected HashMap<String, Facet> facetMap = new HashMap<String, Facet>();

	protected Query luceneQuery = null;
	protected FullTextQuery query = null;
	protected FullTextSession fullTextSession;
	
	protected FacetManager facetManager = null;
	
	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;
	
	protected String searchTerms = "";
	protected String facetFields = "";
	protected String facetTopNs = "";
	protected String narrowFacets = "";
	protected String sortFields = "";
	protected String sortDirections = "";
	
	
	protected Operator op = Operator.OR; 
	protected Analyzer analyzer;
	protected Class<?> entityClass;
	protected long searchTime = 0;
	protected Sort sortObj;

	public SearchQuery() {
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F addFieldConstraint(String fieldname, String terms) {
		
		constraints.put(fieldname, terms);
		updateFullTextQuery = true;
		
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
		updateLuceneQuery = true;
		return (F) this;
	}
	
	private void enableFieldConstraintFilter(String field, String value) {
		query.enableFullTextFilter("fieldConstraintFilter").setParameter("field", field).setParameter("value", value);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F resetSorting() {
		sortObj = null;
		this.sortFields = "";
		this.sortDirections = "";
		updateFullTextQuery = true;
		return (F)this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F sortDesc(String field){
		sort(field, false);
		return (F)this;
	}
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F sortAsc(String field){
		sort(field, true);
		return (F)this;
	}
	
	private void sort(String field, boolean reverse){		
		
		if(sortObj == null){
			this.sortFields = field;
			this.sortDirections = String.valueOf(reverse);	
			sortObj = new Sort();
		}
		else{
			this.sortFields += "," + field;
			this.sortDirections += "," + String.valueOf(reverse);
		}
		
		SortField[] sfs = sortObj.getSort();
		SortField[] newSfs = Arrays.copyOf(sfs, sfs.length+1);		
		newSfs[sfs.length] = new SortField(field, sortType(field), reverse);		
		sortObj.setSort(newSfs);
		
		updateFullTextQuery = true;
	}
	
	//Currently not working correctly on embedded collections see: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-726
	public List<WebDSLFacet> facets(String field, int topN) {
		String facetName = "facet_" + field;
		ArrayList<WebDSLFacet> webDSLFacets;
		List<Facet> facets;
		if (validateQuery())
			facets = query.getFacetManager().getFacets(facetName);
		else
			facets = new ArrayList<Facet>();
		
		if(facets.isEmpty()) {
			QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
			FacetingRequest facetReq = builder
				.facet()
				.name(facetName)
				.onField(field)
				.discrete().orderedBy(FacetSortOrder.COUNT_DESC)
				.includeZeroCounts(false).maxFacetCount(topN)
				.createFacetingRequest();
			
			facets = query.getFacetManager().enableFaceting(facetReq).getFacets(facetName);
			
			if(!facets.isEmpty()){
				this.facetFields += "," + field;
				this.facetTopNs += "," + topN;
				recordFacets(facets);
			}
		}

		webDSLFacets = new ArrayList<WebDSLFacet>();
		for (Facet f : facets)
			webDSLFacets.add(new WebDSLFacet(f));
		
		return webDSLFacets;
		
	}
	
	private void recordFacets(List<Facet> facets){
		String key;
		for (Facet facet : facets) {
			key = facet.getFieldName() + ":" + facet.getValue();
			facetMap.put(key, facet);			
		}
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F narrowOnFacet(WebDSLFacet facet) {
		narrowFacets += "," + facet.getFieldName() + ":" + facet.getValue();
		Facet actualFacet = facetMap.get(facet.getFieldName() + ":" + facet.getValue());
		
		String facetName = actualFacet.getFacetingName();
		query.getFacetManager().getFacetGroup(facetName).selectFacets(actualFacet);

		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	private <F extends SearchQuery<EntityClass>> F setRangeQuery(Object from, Object to) {
		QueryBuilder builder = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		luceneQuery = builder.range().onField(searchFields[0]).from(from).to(to).excludeLimit().createQuery();
		updateLuceneQuery = false;
		updateFullTextQuery = true;
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

		updateLuceneQuery = true;
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
	
	public String highlight(String field, String toHighLight, String preTag, String postTag){
		return ResultHighlighter.highlight(this, field, toHighLight, preTag, postTag);
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
		updateLuceneQuery = false;
		updateFullTextQuery = true;

		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultAnd() {
		if (!op.equals(Operator.AND)){	
			op = Operator.AND;
			updateLuceneQuery = true;
		}
		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultOr() {
		if (!op.equals(Operator.OR)){	
			op = Operator.OR;
			updateLuceneQuery = true;
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
		updateLuceneQuery = true;
		return (F) this;
	}

	private boolean validateQuery() {
		if (updateLuceneQuery) {
			if(!createMultiFieldQuery())
				return false;
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		if (updateFullTextQuery) {
			query = fullTextSession.createFullTextQuery(luceneQuery, entityClass);
			applyFieldConstraints();
			if(sortFields.length() > 1)
				query.setSort(sortObj);
			updateFullTextQuery = false;
		}
		query.setFirstResult(offset);
		query.setMaxResults(limit);

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
	
	private String encode(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p");
	}
	
	private String decode(String str){
		return str.replaceAll("\\\\p", "|").replaceAll("\\\\\\\\ ", "\\\\");
	}
	
	public String encodeAsString(){
		StringBuilder sb = new StringBuilder();
		//0 search fields
		for(int cnt = 0 ; cnt < searchFields.length-1; cnt++)
			sb.append(searchFields[cnt] + ",");
		sb.append(searchFields[searchFields.length-1]);
		//1 search terms
		sb.append("|" + encode(searchTerms));
		//2 default operator
		sb.append("|" + op);
		//3 constraint fields
		sb.append("|");
		for (String field : constraints.keySet()) sb.append(field + ",");		
		//4 constraint values
		sb.append("|");
		for (String value : constraints.values()) sb.append(value + ",");
		//5 facet fields
		sb.append("|");
		sb.append(facetFields.replaceFirst(",", ""));		
		//6 facet top n's
		sb.append("|");
		sb.append(facetTopNs.replaceFirst(",", ""));		
		//7 limit
		sb.append("|" + limit);
		//8 offset
		sb.append("|" + offset);
		//9 boost fields
		sb.append("|");
		for (String field : boosts.keySet()) sb.append(field + ",");		
		//10 boost values
		sb.append("|");
		for (Float value : boosts.values()) sb.append(value + ",");
		//11 narrowed facets
		sb.append("|");
		sb.append(narrowFacets.replaceFirst(",", ""));
		//12 sort fields
		sb.append("|" + sortFields);
		//13 sort directions
		sb.append("|" + sortDirections);
		
		return sb.toString();
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F decodeFromString(String searchQueryAsString){
		System.out.println("+");
		String[] props = searchQueryAsString.split("\\|", -1);
		String[] a1, a2;
		// search fields
		fields(new ArrayList<String>(Arrays.asList(props[0].split(","))));		
		//search terms
		terms(decode(props[1]));
		//default operator
		if(props[2].equals("AND"))
			defaultAnd();
		//boost fields, values
		if(!props[9].isEmpty()){
			a1 = props[9].split(",");
			a2 = props[10].split(",");
			for(int i=0; i < a1.length; i++)
				boost(a1[i], Float.parseFloat(a2[i]));
		}
		//constraint fields, values
		if(!props[3].isEmpty()){
			a1 = props[3].split(",");
			a2 = props[4].split(",");
			for(int i=0; i < a1.length; i++)
				addFieldConstraint(a1[i], a2[i]);
		}
		//facet fields, top n's
		if(!props[5].isEmpty()){
			a1 = props[5].split(",");
			a2 = props[6].split(",");
			for(int i=0; i < a1.length; i++)
				facets(a1[i], Integer.parseInt(a2[i]));
		}
		//narrowed facets
		if(!props[11].isEmpty()){
			a1 = props[11].split(",");
			for(int i=0; i < a1.length; i++)
				narrowOnFacet(new WebDSLFacet(a1[i]));			
		}
		//limit
		maxResults(Integer.parseInt(props[7]));
		//offset
		firstResult(Integer.parseInt(props[8]));
		//sort fields, directions
		if(!props[12].isEmpty()){
			a1 = props[12].split(",");
			a2 = props[13].split(",");
			for(int i=0; i < a1.length; i++)
				sort(a1[i], Boolean.getBoolean(a2[i]));
		}
		
		return (F) this;		
		
	}
	
	public abstract Directory spellDirectoryForField(String field);
	public abstract int sortType(String field);
}