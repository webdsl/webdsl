package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.queryParser.QueryParser.Operator;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.BooleanQuery;
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
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetSortOrder;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.store.DirectoryProvider;
import org.webdsl.WebDSLEntity;

public abstract class AbstractEntitySearcher<EntityClass extends WebDSLEntity> {

	protected static final Version LUCENEVERSION 		= Version.LUCENE_31;
	protected static final int LIMIT 					= 50;
	protected static final int OFFSET 					= 0;
	protected static final Operator OP  				= Operator.OR;
	protected static final boolean ALLOWLUCENESYNTAX 	= true;
	
	protected int limit = LIMIT;
	protected int offset = OFFSET;
	protected Operator defaultOperator = OP;
	
	protected boolean updateFullTextQuery, updateSorting, updateFacets, updateNamespaceConstraint, updateFieldConstraints, updateLuceneQuery = true, updateParamMap = true;
	protected boolean allowLuceneSyntax = true, searchFieldsChanged = false;

	protected HashMap<String, String> fieldConstraints;
	protected HashMap<String, Float> boosts;
	protected HashMap<String, Facet> facetMap;
	protected HashMap<String, String> facetRequests;
	protected Map<String, String> paramMap;

	protected LinkedList<WebDSLFacet> filteredFacetsList = new LinkedList<WebDSLFacet>();
	
	protected Query luceneQuery = null;
	protected FullTextQuery fullTextQuery = null;
	protected FullTextSession fullTextSession;
	
	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;
	protected String indexName;
	
	//protected String queryText = "";
	protected String filteredFacets = "";
	protected String sortFields = "";
	protected String sortDirections = "";
	protected String moreLikeThisParams = "";
	
	protected QueryDef rootQD, currentQD, parentQD;
	
	protected String namespaceConstraint = "";
	
	protected Analyzer analyzer;
	protected Class<?> entityClass;
	protected long searchTime = 0;
	protected Sort sortObj;

	public AbstractEntitySearcher() {		
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F filterByField(String fieldname, String terms) {
		if(fieldConstraints == null)
			fieldConstraints = new HashMap<String, String>();
		
		fieldConstraints.put(fieldname, terms);
		updateFieldConstraints = updateParamMap = true;
		return (F) this;
	}
	
	public String getFieldFilterValue(String fieldname) {
		if(fieldConstraints == null)
			fieldConstraints = new HashMap<String, String>();
		
		return fieldConstraints.get(fieldname);
	}
	
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F allowLuceneSyntax(boolean b) {
		if(this.allowLuceneSyntax != b) {
			this.allowLuceneSyntax = b;
			updateLuceneQuery = updateParamMap = true;
		}
		return (F) this;
	}
	
	// a AND (b OR c)
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F MUST() {
		addSubQuery(Occur.MUST);
		return (F) this;
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F MUSTNOT() {
		addSubQuery(Occur.MUST_NOT);
		return (F) this;
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F SHOULD() {
		addSubQuery(Occur.SHOULD);
		return (F) this;
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F closeGroup() {
		parentQD = parentQD.parent;
		return (F) this;
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F openGroup() {
		parentQD = currentQD;
		return (F) this;
	}
	private final void addSubQuery(Occur oc) {		
		currentQD = new QueryDef(oc, parentQD, searchFields);
	}
	
	private void applyFacets() {
		if(facetMap == null)
			facetMap = new HashMap<String, Facet>();
		String key, facetName;
				
		for(WebDSLFacet facet : filteredFacetsList){
			
			key = facet.getFieldName() + "-" + facet.getValue();
			
			if (!facetMap.containsKey(key)){
				// Facets are not yet retrieved during this object's life cycle, probably this is a reconstructed search query
				getFacets(facet.getFieldName());
			}
			Facet actualFacet = facetMap.get(key);
			if(actualFacet == null) {
				log("Facet to narrow not found, should not happen!");
				continue;
			}
			
			facetName = actualFacet.getFacetingName();
			//This uses the custom .must() method, introduced to state that every facet MUST appear, instead of SHOULD.
			//See https://forum.hibernate.org/viewtopic.php?f=9&t=1011661 for more info.
			fullTextQuery.getFacetManager().getFacetGroup(facetName).must().selectFacets(actualFacet);
		}
	}

	private void applyFieldConstraints() {
		for (String field : fieldConstraints.keySet())
			enableFieldConstraintFilter(field, fieldConstraints.get(field));
	}
	
	private void applyNamespaceConstraint(){
		fullTextQuery.enableFullTextFilter("namespaceFilter")
		.setParameter("indexName", indexName)
		.setParameter("namespaceID", namespaceConstraint);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F boost(String field, Float boost) {
		if(boosts == null)
			boosts = new HashMap<String, Float>();
		if (boosts.containsKey(field))
			boosts.remove(field);
		
		boosts.put(field, boost);
		updateLuceneQuery = updateParamMap = true;
		return (F) this;
	}
	public void closeReader(IndexReader reader){
		if(reader != null)
		getFullTextSession().getSearchFactory().getReaderProvider().closeReader(reader);
	}
	
	private Query createMultiFieldQuery(QueryDef qd) throws ParseException{
		if(qd.hasParsedQuery)
			return luceneQueryFromString(qd.parsedQuery);
		
		if (!qd.query.isEmpty()) {			
			SpecialMultiFieldQueryParser parser;
			if(boosts == null || boosts.isEmpty()) 
				parser = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer);
			 else 
				parser = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer, boosts);
						
			parser.setDefaultOperator(defaultOperator);
			
			try {
				if(allowLuceneSyntax)
					return parser.parse(qd.query);
				else
					return parser.parse(SpecialMultiFieldQueryParser.escape(qd.query));
			} catch (org.apache.lucene.queryParser.ParseException pe){
				pe.printStackTrace();
				return null;
			}
			//log("Terms: " + query());
			//log("Lucene query: " + luceneQuery.toString());
			
		}
		// Match all documents if no search terms are given
		else {
			return getFullTextSession().getSearchFactory()
					.buildQueryBuilder().forEntity(entityClass).get().all()
					.createQuery();
		}
	}
	
	private String decodeValue(String str){
		return str.replaceAll("\\\\a", ":").replaceAll("\\\\c",",").replaceAll("\\\\p", "|").replaceAll("\\\\\\\\ ", "\\\\");
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F defaultAnd() {
		if (!defaultOperator.equals(Operator.AND)){	
			defaultOperator = Operator.AND;
			updateLuceneQuery = updateParamMap = true;
		}
		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F defaultOr() {
		if (!defaultOperator.equals(Operator.OR)){	
			defaultOperator = Operator.OR;
			updateLuceneQuery = updateParamMap = true;
		}		
		return (F) this;
	}
	
	private void enableFieldConstraintFilter(String field, String value) {
		fullTextQuery.enableFullTextFilter("fieldConstraintFilter")
			.setParameter("field", field)
			.setParameter("value", value)
			.setParameter("analyzer", analyzer)
			.setParameter("allowLuceneSyntax", allowLuceneSyntax);
	}
		
	public final Map<String,String> toParamMap(){
		if(!updateParamMap) {
			return paramMap;
		}
		
		paramMap = new HashMap<String, String>();
		StringBuilder sb;
		
		if(searchFieldsChanged) {
		sb = new StringBuilder();
		for(int cnt = 0 ; cnt < searchFields.length-1; cnt++)
			sb.append(searchFields[cnt] + ",");
		sb.append(searchFields[searchFields.length-1]);
		paramMap.put("sf", sb.toString());
		}
		//search terms
		if(rootQD.children.size() < 1)
			paramMap.put("q", rootQD.query);
		else
			paramMap.put("lq", getLuceneQueryAsString());
		
		//default operator
		if(!OP.equals(defaultOperator))
			paramMap.put("op", defaultOperator.toString());
		
		//constraint fields, values
		if(fieldConstraints!=null && !fieldConstraints.isEmpty()){
			sb = new StringBuilder();
			for (String field : fieldConstraints.keySet()) sb.append(field + ",");
			paramMap.put("cf", sb.toString());
			
			sb = new StringBuilder();
			for (String value : fieldConstraints.values()) sb.append(value + ",");
			paramMap.put("cv", sb.toString());
		}		
		
		//facet fields, params
		if(facetRequests !=null && !facetRequests.isEmpty()){
			sb = new StringBuilder();
			for(String field : facetRequests.keySet()) sb.append(field + ",");
			paramMap.put("ff", sb.toString());
			
			sb = new StringBuilder();
			for(String param : facetRequests.values()) sb.append(encodeValue(param) + ",");
			paramMap.put("fp", sb.toString());

		}
		//limit
		if(LIMIT != limit)
			paramMap.put("lim", String.valueOf(limit));
		//offset
		if(OFFSET != offset)
			paramMap.put("offset", String.valueOf(offset));
		
		//boost fields, values		
		if(boosts!=null && !boosts.isEmpty()) {
			sb = new StringBuilder();
			for (String field : boosts.keySet()) sb.append(field + ",");
			paramMap.put("bf", sb.toString());
			sb = new StringBuilder();
			for (Float value : boosts.values()) sb.append(value + ",");
			paramMap.put("bv", sb.toString());
		}
		
		//narrowed facets
		if(!filteredFacets.isEmpty())
			paramMap.put("facetf", filteredFacets);
		
		//sort fields
		if(!sortFields.isEmpty())
			paramMap.put("sortby", sortFields);
		
		//sort directions
		if(!sortDirections.isEmpty())
			paramMap.put("dirs", sortDirections);

		//more like this
		if(!moreLikeThisParams.isEmpty())
			paramMap.put("mlt", moreLikeThisParams);
		
		//allow lucene syntax?
		if(ALLOWLUCENESYNTAX != allowLuceneSyntax)
			paramMap.put("allowlcn", String.valueOf(allowLuceneSyntax));
		
		//namespace constraint?
		if(!namespaceConstraint.isEmpty())
			paramMap.put("ns", namespaceConstraint);
		
		updateParamMap = false;
		return paramMap;		
	}	
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F fromParamMap(Map<String,String> paramMap){
		try{
			String key, value;
			for (Map.Entry<String,String> e : paramMap.entrySet()) {
				key = e.getKey();
				value = e.getValue();
				if ("sf".equals(key)) {
					// search fields
					fields(new ArrayList<String>(Arrays.asList(value.split(","))));
				} else if ("q".equals(key)) {
					//search query
					query(value);
				} else if ("lq".equals(key)) {
					//search query, lucene string representation
					currentQD.parsedQuery(value);
				} else if ("op".equals(key) && value.equals("AND")) {
					//change default operator to AND
					defaultAnd();
				} else if ("cf".equals(key)) {
					//constraint fields, values
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("cv").split(",");
					for(int i=0; i < a1.length; i++)
						filterByField(a1[i], a2[i]);
				} else if ("ff".equals(key)) {
					//facet fields, params
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("fp").split(",");
					String field;
					String param;
					facetRequests = new HashMap<String, String>();
					for(int i=0; i < a1.length; i++){
						field = a1[i];
						param = decodeValue(a2[i]);
						if(param.contains(","))
							enableFaceting(field, param);
						else
							enableFaceting(field, Integer.parseInt(param));
					}
					
				} else if ("lim".equals(key)) {
					//limit
					maxResults(Integer.parseInt(value));
				} else if ("offset".equals(key)) {
					//offset
					firstResult(Integer.parseInt(value));
				} else if ("bf".equals(key)) {
					//boost fields, values
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("bv").split(",");
					for(int i=0; i < a1.length; i++)
						boost(a1[i], Float.parseFloat(a2[i]));
				} else if ("facetf".equals(key)) {
					String[] a1 = value.split(",");
					for(int i=0; i < a1.length; i++)
						filterByFacet(new WebDSLFacet(decodeValue(a1[i])));
				} else if ("sortby".equals(key)) {
					//sort fields, directions
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("dirs").split(",");
					for(int i=0; i < a1.length; i++)
						sort(a1[i], Boolean.getBoolean(a2[i]));
				} else if ("mlt".equals(key)) {
					//more like this
					String[] a1 = value.split(",");
					moreLikeThis(a1[0], Integer.parseInt(a1[1]), Integer.parseInt(a1[2]), Integer.parseInt(a1[3]), Integer.parseInt(a1[4]), Integer.parseInt(a1[5]), Integer.parseInt(a1[6]));
				} else if ("allowlcn".equals(key)) {
					// allow Lucene syntax?
					Boolean.parseBoolean(value);					
				} else if ("ns".equals(key)) {
					//namespace
					setNamespace(value);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log("Error during entity searcher decoding!");
		}
		
		this.paramMap = paramMap;
		updateParamMap = false;
		return (F) this;		
		
	}
	
	
	private String encodeValue(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p").replaceAll(",", "\\\\c").replaceAll(":", "\\\\a");
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F enableFaceting(String field, int topN){		
		if(facetRequests == null)
			facetRequests = new HashMap<String, String>();
		
		facetRequests.put(field, String.valueOf(topN));
		updateParamMap = true;
		
		return (F) this;
	}
	
	// example ranges: "(,100)(100,200)(200,)"   "(-200,-100)(-100,0)(0,)"
	// Bug on numeric fields: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-770
	// Therefore using custom Hibernate Search jar, but still includes entities with null values on the faceting field in counts :(
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F enableFaceting(String field, String rangesAsString) {
		if(facetRequests == null)
			facetRequests = new HashMap<String, String>();

		facetRequests.put(field, rangesAsString);
		updateParamMap = true;
	
		return (F) this;		
	}
	
	private void enableFacets(){
		for(Map.Entry<String, String> facetEntry : facetRequests.entrySet()){
			if(facetEntry.getValue().contains(","))
				this.enableRangeFacet(facetEntry.getKey(), facetEntry.getValue());
			else
				this.enableDiscreteFacet(facetEntry.getKey(), Integer.parseInt(facetEntry.getValue()));
		}
	}
	
	private void enableDiscreteFacet(String field, int topN){
		String facetName = WebDSLFacetTool.facetName(field);
		
		QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		FacetingRequest facetReq = builder
			.facet()
			.name(facetName)
			.onField(field)
			.discrete()
			.orderedBy(FacetSortOrder.COUNT_DESC)
			.includeZeroCounts(false).maxFacetCount(topN)
			.createFacetingRequest();
		
		fullTextQuery.getFacetManager().enableFaceting(facetReq);
	}
	
	private void enableRangeFacet(String field, String rangesAsString){
		FacetingRequest facetReq  = WebDSLFacetTool.toFacetingRequest(field, rangesAsString, entityClass, fieldType(field), getFullTextSession());
		
		fullTextQuery.getFacetManager().enableFaceting(facetReq);
	}
	
	
		
	//Currently not working correctly on embedded collections see: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-726
	public List<WebDSLFacet> getFacets(String field) {

		String facetName = WebDSLFacetTool.facetName(field);
		List<Facet> facets;
		if (validateQuery()){
			facets = fullTextQuery.getFacetManager().getFacets(facetName);
			//If no facets are returned, facets are probably not enabled yet
			if(facets.isEmpty()){
				enableFacets();
				facets = fullTextQuery.getFacetManager().getFacets(facetName);
			}
		}			
		else
			return new ArrayList<WebDSLFacet>();
	
		return toWebDSLFacets(facets);
		
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F field(String field){
		return (F) fields(new ArrayList<String>(Arrays.asList(field) ));
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F fields(List<String> fields) {
		searchFields = fields.toArray(new String[fields.size()]);
		//no need to clone searchFields, because variable searchFields is only reassigned and never modified.
		currentQD.fields = searchFields;
		
		//Untokenized fields should be excluded from more like this queries
		for (int i = 0; i < untokenizedFields.length; i++)
			fields.remove(untokenizedFields[i]);			
		mltSearchFields = fields.toArray(new String[fields.size()]);

		searchFieldsChanged = updateLuceneQuery = updateParamMap = true;
		return (F) this;
	}
	
	public abstract Class<?> fieldType(String field);
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F setNamespace(String namespace){
		
		if(!namespaceConstraint.equals(namespace)){
			//first remove old namespace filter if set
			if(!namespaceConstraint.isEmpty())
				fullTextQuery.disableFullTextFilter("namespaceFilter");
		}
		else {
			return (F) this;
		}
		namespaceConstraint = namespace;
		updateNamespaceConstraint = updateParamMap = true;
		return (F) this;
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F removeNamespace(){
		fullTextQuery.disableFullTextFilter("namespaceFilter");
		namespaceConstraint = "";
		updateParamMap = true;
		return (F) this;
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F firstResult(int offset) {
		this.offset = offset;
		updateParamMap = true;
		return (F) this;
	}

	protected abstract FullTextSession getFullTextSession ();
	
	protected abstract int directoryProviderIndexForNamespace ();

	public IndexReader getReader() {
		SearchFactory searchFactory = getFullTextSession().getSearchFactory();
		DirectoryProvider<?>[] providers = searchFactory
				.getDirectoryProviders(entityClass);
		if(namespaceConstraint.isEmpty()) {
			return searchFactory.getReaderProvider().openReader(providers);
		} else {
			int index = directoryProviderIndexForNamespace();
			return searchFactory.getReaderProvider().openReader(providers[index]);
		}		
	}
	
	public static String escapeQuery(String query){
		return QueryParser.escape(query);
	}
	
	public String highlight(String field, String toHighLight){
		return ResultHighlighter.highlight(this, field, toHighLight);
	}

	public String highlight(String field, String toHighLight, String preTag, String postTag){
		return ResultHighlighter.highlight(this, field, toHighLight, preTag, postTag);
	}
	
	@SuppressWarnings("unchecked")
	public List<EntityClass> list() {
		try{
			searchTime = System.currentTimeMillis();
			if (validateQuery()) {			
				List<EntityClass> toReturn = fullTextQuery.list();
				searchTime = System.currentTimeMillis() - searchTime;
				//log("got result list in " + searchTime +"ms");
				return toReturn;
			}
		} catch(Exception ex) {
			log("ERROR WHILE LISTING SEARCH RESULTS");
			ex.printStackTrace();
		}
		//Something went wrong
		searchTime = 0;
		return new ArrayList<EntityClass>();
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F maxResults(int limit) {
		this.limit = limit;
		updateParamMap = true;
		return (F) this;
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F moreLikeThis(String likeText) {
		int minWordLen = 5, maxWordLen = 30, minDocFreq = 1, minTermFreq = 3, maxQueryTerms = 6, maxDocFreqPct = 100;
		return (F) moreLikeThis(likeText, minWordLen, maxWordLen, minDocFreq, maxDocFreqPct,
				minTermFreq, maxQueryTerms);
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F moreLikeThis(
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
		updateFullTextQuery = updateParamMap = true;

		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F filterByFacet(WebDSLFacet facet) {
		String key = encodeValue(facet.getFieldName() + "-" + facet.getValue());
				
		//if already narrowed on this facet, don't add it again
		if(filteredFacets.contains(key))
			return (F) this;
		
		if(!filteredFacets.isEmpty())
			filteredFacets += "," + key;
		else
			filteredFacets += key;

		filteredFacetsList.add(facet);
	
		updateFacets = updateParamMap = true;
		
		return (F) this;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F range(Date from, Date to) {
		return (F) setRangeQuery(from,to);
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F range(Float from, Float to) {
		return (F) setRangeQuery(from,to);
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F range(int from, int to) {
		return (F) setRangeQuery(from,to);
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F range(String from, String to) {
		return (F) setRangeQuery(from,to);
	}

	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F resetSorting() {
		sortObj = null;
		this.sortFields = "";
		this.sortDirections = "";
		updateSorting = updateParamMap = true;
		return (F)this;
	}

	public int resultSize() {
		try{
			if (validateQuery()){
				return fullTextQuery.getResultSize();
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		}
		//Something went wrong
		return 0;
	}
	public String searchTimeAsString() {
		return searchTime + " ms";
	}

	public int searchTimeMillis() {
		return (int) this.searchTime;
	}

	public float searchTimeSeconds() {
		return (float) (this.searchTime / 1000);
	}
	
	@SuppressWarnings("unchecked")
	private <F extends AbstractEntitySearcher<EntityClass>> F setRangeQuery(Object from, Object to) {
		currentQD.range(from, to);
		
		updateLuceneQuery = updateFullTextQuery = updateParamMap = true;
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
		
		updateSorting = updateParamMap = true;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F sortAsc(String field){
		sort(field, false);
		return (F)this;
	}
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F sortDesc(String field){
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
		
	public String query(){
		if(rootQD.children.size() < 1) {
			return rootQD.query;
		}
		else {
			validateQuery();
			return luceneQuery.toString();
		}
			
	}
	
	@SuppressWarnings("unchecked")
	public <F extends AbstractEntitySearcher<EntityClass>> F query(String query) {
		currentQD.query(query);
		updateLuceneQuery = updateParamMap = true;
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
	private void log(String a){
		System.out.println(a);
	}
	
	private String getLuceneQueryAsString(){
		if(updateLuceneQuery){
			try {
				luceneQuery = createLuceneQuery(rootQD);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return luceneQuery.toString("Error occured during query parsing");
			}
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		return luceneQuery.toString();
	}

	private Query luceneQueryFromString(String str) throws ParseException{
		return new QueryParser( LUCENEVERSION, "", this.analyzer).parse(str);
		
	}
	
	private boolean validateQuery() {
		long tmp = System.currentTimeMillis();
		if (updateLuceneQuery) {
			try {
				luceneQuery = createLuceneQuery(rootQD);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
			//log("LUCENE QUERY: " + luceneQuery.toString());
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		if (updateFullTextQuery) {
			fullTextQuery = getFullTextSession().createFullTextQuery(luceneQuery, entityClass);
			updateFullTextQuery = false;
			updateNamespaceConstraint = updateFieldConstraints = updateFacets = updateSorting = true;
		}
		if(updateFieldConstraints && fieldConstraints != null){
			updateFieldConstraints = false;
			applyFieldConstraints();
		}
		if(updateNamespaceConstraint && !namespaceConstraint.isEmpty()){
			updateNamespaceConstraint = false;
			applyNamespaceConstraint();
		}
		if(updateFacets && !filteredFacets.isEmpty()){
			updateFacets = false;
			applyFacets();
		}
		if(updateSorting && !sortFields.isEmpty()){
			updateSorting = false;
			fullTextQuery.setSort(sortObj);
		}
		fullTextQuery.setFirstResult(offset);
		fullTextQuery.setMaxResults(limit);
		tmp = System.currentTimeMillis() - tmp;
		return true;
	}
	
	private Query createLuceneQuery(QueryDef qd) throws ParseException{
		if(qd.children.size() < 1)
			return (qd.isRangeQuery) ? createRangeQuery(qd) : createMultiFieldQuery(qd);
			
		BooleanQuery booleanQuery = new BooleanQuery();

		for (QueryDef child : qd.children)
			booleanQuery.add(createLuceneQuery(child), child.occur);
		
		return booleanQuery;
	}

	private Query createRangeQuery(QueryDef qd) throws ParseException {
		if(qd.hasParsedQuery)
			return luceneQueryFromString(qd.parsedQuery);
		QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		return builder.range().onField(qd.fields[0]).from(qd.from).to(qd.to).createQuery();
	}
}