package org.webdsl.search;

import java.io.File;
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
import org.apache.lucene.util.Version;
import org.hibernate.search.FullTextQuery;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.hibernate.search.query.dsl.impl.WebDSLFacetTool;
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
	
	protected boolean updateLuceneQuery, updateFullTextQuery, updateEncodeString, updateSorting, updateFacets, updateFieldConstraints = true;

	protected HashMap<String, String> constraints;
	protected HashMap<String, Float> boosts;
	protected HashMap<String, Facet> facetMap;
	protected HashMap<String, String> facetRequests;

	protected ArrayList<WebDSLFacet> narrowFacetsList = new ArrayList<WebDSLFacet>();
	
	protected Query luceneQuery = null;
	protected FullTextQuery fullTextQuery = null;
	protected FullTextSession fullTextSession;
	
	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;
	
	protected String searchTerms = "";
	protected String narrowFacets = "";
	protected String sortFields = "";
	protected String sortDirections = "";
	protected String moreLikeThisParams = ""; 
	protected String encodedAsString;
	
	
	protected Operator op = Operator.OR; 
	protected Analyzer analyzer;
	protected Class<?> entityClass;
	protected long searchTime = 0;
	protected Sort sortObj;

	public SearchQuery() {
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F addFieldConstraint(String fieldname, String terms) {
		if(constraints == null)
			constraints = new HashMap<String, String>();
		
		constraints.put(fieldname, terms);
		updateFieldConstraints = updateEncodeString = true;
		
		return (F) this;
	}
	
	private void applyFacets() {
		if(facetMap == null)
			facetMap = new HashMap<String, Facet>();
		String key, facetName;
		for (WebDSLFacet facet : narrowFacetsList) {
			
			key = facet.getFieldName() + "-" + facet.getValue();		
		
			if(!facetMap.containsKey(key)){
				//all range facets contain at least one '('
				if(facetRequests.get(facet.getFieldName()).contains(","))
					this.rangeFacets(facet.getFieldName(), facetRequests.get(facet.getFieldName()));
				else
					this.facets(facet.getFieldName(), Integer.parseInt(facetRequests.get(facet.getFieldName())));
			}
		
			Facet actualFacet = facetMap.get(key);
			facetName = actualFacet.getFacetingName();

			fullTextQuery.getFacetManager().getFacetGroup(facetName).selectFacets(actualFacet);

		}
	}

	private void applyFieldConstraints() {
		for (String field : constraints.keySet())
			enableFieldConstraintFilter(field, constraints.get(field));
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F boost(String field, Float boost) {
		if(boosts == null)
			boosts = new HashMap<String, Float>();
		if (boosts.containsKey(field))
			boosts.remove(field);
		
		boosts.put(field, boost);
		updateLuceneQuery = updateEncodeString = true;
		return (F) this;
	}
	
	public void closeReader(IndexReader reader){
		if(reader != null)
		getFullTextSession().getSearchFactory().getReaderProvider().closeReader(reader);
	}
	
	private boolean createMultiFieldQuery(){
		if (!searchTerms.isEmpty()) {
			
			QueryParser parser;
			if(boosts == null || boosts.isEmpty()) 
				parser = new MultiFieldQueryParser(	luceneVersion, searchFields, analyzer);
			 else 
				parser = new MultiFieldQueryParser(	luceneVersion, searchFields, analyzer, boosts);
						
			parser.setDefaultOperator(op);
			try {
				luceneQuery = parser.parse(searchTerms);
			} catch (org.apache.lucene.queryParser.ParseException pe){ 
				return false;
			}
			
		}
		// Match all documents if no search terms are given
		else {
			luceneQuery = getFullTextSession().getSearchFactory()
					.buildQueryBuilder().forEntity(entityClass).get().all()
					.createQuery();
		}
		return true;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F decodeFromString(String searchQueryAsString){

		F fromCache = (F) SearchQueryMRUCache.getInstance().getObject(searchQueryAsString);
		if(fromCache!=null && !fromCache.updateEncodeString && fromCache.encodedAsString.equals(searchQueryAsString)){
			System.out.println("CACHE HIT");
			fromCache.fullTextSession = null; // needs to be reset
			fromCache.getFullTextSession();
			return fromCache;
		}
		
		//System.out.println("+");
		String[] props = searchQueryAsString.split("\\|", -1);
		String[] a1, a2;
		// search fields
		fields(new ArrayList<String>(Arrays.asList(props[0].split(","))));		
		//search terms
		terms(decodeValue(props[1]));
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
		//facet fields, requests
		if(!props[5].isEmpty()){
			a1 = props[5].split(",");
			a2 = props[6].split(",");
			facetRequests = new HashMap<String, String>();
			for(int i=0; i < a1.length; i++)

				facetRequests.put(a1[i], decodeValue(a2[i]));
			
		}
		//narrowed facets
		if(!props[11].isEmpty()){
			a1 = props[11].split(",");
			for(int i=0; i < a1.length; i++)
				narrowOnFacet(new WebDSLFacet(decodeValue(a1[i])));
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
		//more like this
		if(!props[14].isEmpty()){
			a1 = props[14].split(",");
			moreLikeThis(decodeValue(a1[0]), Integer.parseInt(a1[1]), Integer.parseInt(a1[2]), Integer.parseInt(a1[3]), Integer.parseInt(a1[4]), Integer.parseInt(a1[5]), Integer.parseInt(a1[6]));
		}
		
		encodedAsString = searchQueryAsString;		
		updateEncodeString = false;

		return (F) this;		
		
	}
	private String decodeValue(String str){
		return str.replaceAll("\\\\a", ":").replaceAll("\\\\c",",").replaceAll("\\\\p", "|").replaceAll("\\\\\\\\ ", "\\\\");
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultAnd() {
		if (!op.equals(Operator.AND)){	
			op = Operator.AND;
			updateLuceneQuery = updateEncodeString = true;
		}
		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F defaultOr() {
		if (!op.equals(Operator.OR)){	
			op = Operator.OR;
			updateLuceneQuery = updateEncodeString = true;
		}		
		return (F) this;
	}
	
	private void enableFieldConstraintFilter(String field, String value) {
		fullTextQuery.enableFullTextFilter("fieldConstraintFilter").setParameter("field", field).setParameter("value", value);
	}
	
	public String encodeAsString(){
		if(!updateEncodeString)
			return encodedAsString;
		
		StringBuilder sb = new StringBuilder();
		//0 search fields
		for(int cnt = 0 ; cnt < searchFields.length-1; cnt++)
			sb.append(searchFields[cnt] + ",");
		sb.append(searchFields[searchFields.length-1]);
		//1 search terms
		sb.append("|" + encodeValue(searchTerms));
		//2 default operator
		sb.append("|" + op);
		//3 constraint fields
		sb.append("|");
		if(constraints!=null)
			for (String field : constraints.keySet()) sb.append(field + ",");		
		//4 constraint values
		sb.append("|");
		if(constraints!=null)
			for (String value : constraints.values()) sb.append(value + ",");
		//5 facet fields
		sb.append("|");
		if(facetRequests !=null)
			for(String field : facetRequests.keySet()) sb.append(field + ",");		
		//6 facet params
		sb.append("|");
		if(facetRequests!=null)
			for(String param : facetRequests.values()) sb.append(encodeValue(param) + ",");		
		//7 limit
		sb.append("|" + limit);
		//8 offset
		sb.append("|" + offset);
		//9 boost fields
		sb.append("|");
		if(boosts!=null)
			for (String field : boosts.keySet()) sb.append(field + ",");		
		//10 boost values
		sb.append("|");
		if(boosts!=null)
			for (Float value : boosts.values()) sb.append(value + ",");
		//11 narrowed facets
		sb.append("|");
		sb.append(narrowFacets.replaceFirst(",", ""));
		//12 sort fields
		sb.append("|" + sortFields);
		//13 sort directions
		sb.append("|" + sortDirections);
		//14 more like this
		sb.append("|" + encodeValue(moreLikeThisParams));
		
		//System.out.println("encode-sq");
		updateEncodeString = false;
		encodedAsString = sb.toString().replaceAll(",\\|", "\\|");
		SearchQueryMRUCache.getInstance().putObject(encodedAsString, this);
		return encodedAsString;
		
	}
	
	private String encodeValue(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p").replaceAll(",", "\\\\c").replaceAll(":", "\\\\a");
	}
	
	//Currently not working correctly on embedded collections see: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-726
	public List<WebDSLFacet> facets(String field, int topN) {

		String facetName = WebDSLFacetTool.facetName(field);
		List<Facet> facets;
		if (validateQuery())
			facets = fullTextQuery.getFacetManager().getFacets(facetName);
		else
			return new ArrayList<WebDSLFacet>();
		
		if(facets.isEmpty()) {
			QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
			FacetingRequest facetReq = builder
				.facet()
				.name(facetName)
				.onField(field)
				.discrete()
				.orderedBy(FacetSortOrder.COUNT_DESC)
				.includeZeroCounts(false).maxFacetCount(topN)
				.createFacetingRequest();
			
			facets = fullTextQuery.getFacetManager().enableFaceting(facetReq).getFacets(facetName);
			if(facetRequests == null)
				facetRequests = new HashMap<String, String>();
			
			if(!facets.isEmpty() && !facetRequests.containsKey(field)){
				facetRequests.put(field, String.valueOf(topN));
				updateEncodeString = true;
			}
		}
	
		return toWebDSLFacets(facets);
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F field(String field){
		return (F) fields(new ArrayList<String>(Arrays.asList(field) ));
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F fields(List<String> fields) {		
		searchFields = fields.toArray(new String[fields.size()]);
		
		//Untokenized fields should be excluded from more like this queries
		for (int i = 0; i < untokenizedFields.length; i++)
			fields.remove(untokenizedFields[i]);			
		mltSearchFields = fields.toArray(new String[fields.size()]);

		updateLuceneQuery = updateEncodeString = true;
		return (F) this;
	}
		
	public abstract Class<?> fieldType(String field);
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F firstResult(int offset) {
		this.offset = offset;
		updateEncodeString = true;
		return (F) this;
	}
	
	protected abstract FullTextSession getFullTextSession ();
	
	public IndexReader getReader() {
		SearchFactory searchFactory = getFullTextSession().getSearchFactory();
		DirectoryProvider<?> provider = searchFactory
				.getDirectoryProviders(entityClass)[0];
		ReaderProvider readerProvider = searchFactory.getReaderProvider();
		return readerProvider.openReader(provider);
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
			List<EntityClass> toReturn = fullTextQuery.list();
			searchTime = System.currentTimeMillis() - searchTime;
			return toReturn;
		} else
			searchTime = 0;
			return new ArrayList<EntityClass>();
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F maxResults(int limit) {
		this.limit = limit;
		updateEncodeString = true;
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
			String likeText, int minWordLen, int maxWordLen, int minDocFreq, int maxDocFreqPct, int minTermFreq, int maxQueryTerms) {
		
		moreLikeThisParams = likeText + "," + minWordLen + "," + maxWordLen + "," + minDocFreq + "," + maxDocFreqPct + "," + minTermFreq + "," + maxQueryTerms; 
		
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
		updateFullTextQuery = updateEncodeString = true;

		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F narrowOnFacet(WebDSLFacet facet) {
		String key = encodeValue(facet.getFieldName() + "-" + facet.getValue());
		
		//if already narrowed on this facet, don't add it again
		if(narrowFacets.contains(key))
			return (F) this;
		
		narrowFacets += "," + key;
		narrowFacetsList.add(facet);
	
		updateFacets = updateEncodeString = true;
		
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F range(Date from, Date to) {
		return (F) setRangeQuery(from,to);
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F range(Float from, Float to) {
		return (F) setRangeQuery(from,to);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F range(int from, int to) {
		return (F) setRangeQuery(from,to);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F range(String from, String to) {
		return (F) setRangeQuery(from,to);
	}
	
	// example ranges: "(,100)(100,200)(200,)"   "(-200,-100)(-100,0)(0,)"
	// Bug on numeric fields: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-770
	// Therefore using custom Hibernate Search jar, but still includes entities with null values on the faceting field in counts :(
	public List<WebDSLFacet> rangeFacets(String field, String rangesAsString) {

		String facetName = WebDSLFacetTool.facetName(field);

		List<Facet> facets;
		if (validateQuery()){
			FacetManager fm = fullTextQuery.getFacetManager();
			facets = fm.getFacets(facetName);
		}
		else
			return new ArrayList<WebDSLFacet>();
		
		if(facets.isEmpty()) {

			FacetingRequest facetReq  = WebDSLFacetTool.toFacetingRequest(field, rangesAsString, entityClass, fieldType(field), getFullTextSession());
			
			facets = fullTextQuery.getFacetManager().enableFaceting(facetReq).getFacets(facetName);
			if(facetRequests == null)
				facetRequests = new HashMap<String, String>();
			
			if(!facets.isEmpty() && !facetRequests.containsKey(field)){
				facetRequests.put(field, rangesAsString);
				updateEncodeString = true;
			}
		}
	
		return toWebDSLFacets(facets);
		
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F resetSorting() {
		sortObj = null;
		this.sortFields = "";
		this.sortDirections = "";
		updateSorting = updateEncodeString = true;
		return (F)this;
	}

	public int resultSize() {
		if (validateQuery())
			return fullTextQuery.getResultSize();
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
	@SuppressWarnings("unchecked")
	private <F extends SearchQuery<EntityClass>> F setRangeQuery(Object from, Object to) {
		QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		luceneQuery = builder.range().onField(searchFields[0]).from(from).to(to).excludeLimit().createQuery();
		updateLuceneQuery = false;
		updateFullTextQuery = updateEncodeString = true;
		return (F) this;
	}

	private void sort(String field, boolean reverse){		
		
		if(sortObj == null){
			this.sortFields = field;
			this.sortDirections = String.valueOf(reverse);	
			sortObj = new Sort();
		}
		else{
			//If sort field already exists, don't do anything
			if(sortFields.matches("(^|.*,)" + field + "(,.*|$)")){
				return;
			}
			this.sortFields += "," + field;
			this.sortDirections += "," + String.valueOf(reverse);
		}
		SortField[] sfs = sortObj.getSort();
		SortField[] newSfs = Arrays.copyOf(sfs, sfs.length+1);		
		newSfs[sfs.length] = new SortField(field, sortType(field), reverse);		
		sortObj.setSort(newSfs);
		
		updateSorting = updateEncodeString = true;
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F sortAsc(String field){
		sort(field, false);
		return (F)this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F sortDesc(String field){
		sort(field, true);
		return (F)this;
	}

	public int sortType(String field){
		Class<?> tp = fieldType(field);
		if(tp.isAssignableFrom(String.class))
			return SortField.STRING;
		if (tp.isAssignableFrom(Integer.class))
			return SortField.INT;
		if (tp.isAssignableFrom(Float.class))
			return SortField.FLOAT;
		else
			return SortField.STRING;
	}
	
	public abstract File spellDirectoryForField(String field);
	public abstract File autoCompleteDirectoryForField(String field);
	
	public ArrayList<String> spellSuggest(String toSuggestOn, String field, float accuracy, int noSug){
		searchTime = System.currentTimeMillis();
		ArrayList<String> toReturn = SearchSuggester.findSpellSuggestionsForField(this, field, noSug, accuracy, true, toSuggestOn);
		searchTime = System.currentTimeMillis() - searchTime;		
		return toReturn;
	}
	
	public ArrayList<String> spellSuggest(String toSuggestOn, List<String> fields, float accuracy, int noSug){
		searchTime = System.currentTimeMillis();
		ArrayList<String> toReturn = SearchSuggester.findSpellSuggestions(this, fields, noSug, accuracy, toSuggestOn);
		searchTime = System.currentTimeMillis() - searchTime;		
		return toReturn;
	}
	
	public ArrayList<String> autoCompleteSuggest(String toSuggestOn, String field, int noSug){
		searchTime = System.currentTimeMillis();
		ArrayList<String> toReturn = SearchSuggester.findAutoCompletionsForField(this, field, noSug, toSuggestOn);			
		searchTime = System.currentTimeMillis() - searchTime;
		return toReturn;
	}
	
	public ArrayList<String> autoCompleteSuggest(String toSuggestOn, List<String> fields, int noSug){
		searchTime = System.currentTimeMillis();
		ArrayList<String> toReturn = SearchSuggester.findAutoCompletions(this, fields, noSug, toSuggestOn);			
		searchTime = System.currentTimeMillis() - searchTime;
		return toReturn;
	}
		
	public String terms(){
			return this.searchTerms;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F terms(String terms) {
		searchTerms = terms;
		updateLuceneQuery = updateEncodeString = true;
		return (F) this;
	}
	
	private ArrayList<WebDSLFacet> toWebDSLFacets(List<Facet> facets){
		String key;
		ArrayList<WebDSLFacet> webdslFacets = new ArrayList<WebDSLFacet>();
		
		if(facetMap == null)
			facetMap = new HashMap<String, Facet>();
		
		for (Facet facet : facets) {
			key = facet.getFieldName() + "-" + facet.getValue();
			if(!facetMap.containsKey(key))
				facetMap.put(key, facet);
			webdslFacets.add(new WebDSLFacet(facet));
		}
		return webdslFacets;
	}
	private boolean validateQuery() {
		if (updateLuceneQuery) {
			if(!createMultiFieldQuery())
				return false;	
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		if (updateFullTextQuery) {
			updateFullTextQuery = false;
			fullTextQuery = getFullTextSession().createFullTextQuery(luceneQuery, entityClass);
			updateFacets = updateFieldConstraints = updateSorting = true;
		}
		if(updateFieldConstraints && constraints != null){
			updateFieldConstraints = false;
			applyFieldConstraints();
		}
		if(updateFacets && narrowFacets.length() > 1){
			updateFacets = false;
			applyFacets();
		}
		if(updateSorting && sortFields.length() > 1){
			updateSorting = false;
			fullTextQuery.setSort(sortObj);
		}
		
		fullTextQuery.setFirstResult(offset);
		fullTextQuery.setMaxResults(limit);

		return true;
	}
}