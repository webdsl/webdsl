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
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetSortOrder;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.store.DirectoryProvider;
import org.webdsl.WebDSLEntity;

public abstract class SearchQuery<EntityClass extends WebDSLEntity> {

	protected final Version luceneVersion = Version.LUCENE_31;
	
	protected int limit = 50;
	protected int offset = 0;
	
	protected boolean updateFullTextQuery, updateSorting, updateFacets, updateNamespaceConstraint, updateFieldConstraints, updateLuceneQuery = true, updateEncodeString = true;
	protected boolean allowLuceneSyntax = true;

	protected HashMap<String, String> fieldConstraints;
	protected HashMap<String, Float> boosts;
	protected HashMap<String, Facet> facetMap;
	protected HashMap<String, String> facetRequests;

	protected LinkedList<WebDSLFacet> filteredFacetsList = new LinkedList<WebDSLFacet>();
	
	protected Query luceneQuery = null;
	protected FullTextQuery fullTextQuery = null;
	protected FullTextSession fullTextSession;
	
	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;
	
	protected String queryText = "";
	protected String filteredFacets = "";
	protected String sortFields = "";
	protected String sortDirections = "";
	protected String moreLikeThisParams = ""; 
	protected String encodedAsString;
	
	protected String namespaceConstraint = "";
	
	
	protected Operator op = Operator.OR; 
	protected Analyzer analyzer;
	protected Class<?> entityClass;
	protected long searchTime = 0;
	protected Sort sortObj;

	public SearchQuery() {
	}

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F filterByField(String fieldname, String terms) {
		if(fieldConstraints == null)
			fieldConstraints = new HashMap<String, String>();
		
		fieldConstraints.put(fieldname, terms);
		updateFieldConstraints = updateEncodeString = true;
		return (F) this;
	}
	
	public String getFieldFilterValue(String fieldname) {
		if(fieldConstraints == null)
			fieldConstraints = new HashMap<String, String>();
		
		return fieldConstraints.get(fieldname);
	}
	
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F allowLuceneSyntax(boolean b) {
		if(this.allowLuceneSyntax != b) {
			this.allowLuceneSyntax = b;
			updateLuceneQuery = updateEncodeString = true;
		}
		return (F) this;
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
		.setParameter("entityName", entityClass.getName())
		.setParameter("namespaceID", namespaceConstraint);
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
		if (!queryText.isEmpty()) {
			
			SpecialMultiFieldQueryParser parser;
			if(boosts == null || boosts.isEmpty()) 
				parser = new SpecialMultiFieldQueryParser(	luceneVersion, searchFields, analyzer);
			 else 
				parser = new SpecialMultiFieldQueryParser(	luceneVersion, searchFields, analyzer, boosts);
						
			parser.setDefaultOperator(op);
			
			try {
				if(allowLuceneSyntax)
					luceneQuery = parser.parse(queryText);
				else
					luceneQuery = parser.parse(SpecialMultiFieldQueryParser.escape(queryText));
			} catch (org.apache.lucene.queryParser.ParseException pe){ 
				return false;
			}
			//log("Terms: " + terms());
			//log("Lucene query: " + luceneQuery.toString());
			
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
		try{
			String[] props = searchQueryAsString.split("\\|", -1);
			if(props.length != 17){
				log("MALFORMED SEARCHQUERY ENCODING!");
				return (F) this;
			}		
			String[] a1, a2;
			// search fields
			fields(new ArrayList<String>(Arrays.asList(props[0].split(","))));
			// allow Lucene syntax?
			allowLuceneSyntax(Boolean.parseBoolean(props[15]));
			//search terms
			query(decodeValue(props[1]));
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
					filterByField(a1[i], a2[i]);
			}
			//namespace constraint
			if(!props[16].isEmpty()){
				setNamespace(decodeValue(props[16]));
			}
			//facet fields, requests
			if(!props[5].isEmpty()){
				a1 = props[5].split(",");
				a2 = props[6].split(",");
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
			}
			
			//narrowed facets
			if(!props[11].isEmpty()){
				a1 = props[11].split(",");
				for(int i=0; i < a1.length; i++)
					filterByFacet(new WebDSLFacet(decodeValue(a1[i])));
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
		} catch (Exception ex){
			//exception, so return a new query
			try {
				log("MALFORMED SEARCHQUERY ENCODING!");
				this.getClass().newInstance();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
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
		fullTextQuery.enableFullTextFilter("fieldConstraintFilter")
			.setParameter("field", field)
			.setParameter("value", value)
			.setParameter("analyzer", analyzer)
			.setParameter("allowLuceneSyntax", allowLuceneSyntax);
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
		sb.append("|" + encodeValue(queryText));
		//2 default operator
		sb.append("|" + op);
		//3 constraint fields
		sb.append("|");
		if(fieldConstraints!=null)
			for (String field : fieldConstraints.keySet()) sb.append(field + ",");		
		//4 constraint values
		sb.append("|");
		if(fieldConstraints!=null)
			for (String value : fieldConstraints.values()) sb.append(value + ",");
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
		sb.append(filteredFacets);
		//12 sort fields
		sb.append("|" + sortFields);
		//13 sort directions
		sb.append("|" + sortDirections);
		//14 more like this
		sb.append("|" + encodeValue(moreLikeThisParams));
		//15 allow lucene syntax?
		sb.append("|" + allowLuceneSyntax);
		//16 namespace constraint?
		sb.append("|" + encodeValue(namespaceConstraint));
		
		//log("encode-sq");
		updateEncodeString = false;
		encodedAsString = sb.toString().replaceAll(",\\|", "\\|");
		//SearchQueryMRUCache.getInstance().putObject(encodedAsString, this);
		return encodedAsString;
		
	}
	
	private String encodeValue(String str){
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\|", "\\\\p").replaceAll(",", "\\\\c").replaceAll(":", "\\\\a");
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F enableFaceting(String field, int topN){		
		if(facetRequests == null)
			facetRequests = new HashMap<String, String>();
		
		facetRequests.put(field, String.valueOf(topN));
		updateEncodeString = true;
		
		return (F) this;
	}
	
	// example ranges: "(,100)(100,200)(200,)"   "(-200,-100)(-100,0)(0,)"
	// Bug on numeric fields: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-770
	// Therefore using custom Hibernate Search jar, but still includes entities with null values on the faceting field in counts :(
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F enableFaceting(String field, String rangesAsString) {
		if(facetRequests == null)
			facetRequests = new HashMap<String, String>();

		facetRequests.put(field, rangesAsString);
		updateEncodeString = true;
	
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
	public <F extends SearchQuery<EntityClass>> F setNamespace(String namespace){
		if (namespaceConstraint.isEmpty()) {
			//do nothing special
		}
		else if(!namespaceConstraint.equals(namespace)){
			//first remove old namespace filter
			fullTextQuery.disableFullTextFilter("namespaceFilter");
		}
		else {
			return (F) this;
		}
		namespaceConstraint = namespace;
		updateNamespaceConstraint = updateEncodeString = true;
		return (F) this;
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F removeNamespace(){
		fullTextQuery.disableFullTextFilter("namespaceFilter");
		namespaceConstraint = "";
		updateEncodeString = true;
		return (F) this;
		
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F firstResult(int offset) {
		this.offset = offset;
		updateEncodeString = true;
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
		searchTime = System.currentTimeMillis();
		if (validateQuery()) {
			List<EntityClass> toReturn = fullTextQuery.list();
			searchTime = System.currentTimeMillis() - searchTime;
			//log("got result list in " + searchTime +"ms");
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
	public <F extends SearchQuery<EntityClass>> F filterByFacet(WebDSLFacet facet) {
		String key = encodeValue(facet.getFieldName() + "-" + facet.getValue());
				
		//if already narrowed on this facet, don't add it again
		if(filteredFacets.contains(key))
			return (F) this;
		
		if(!filteredFacets.isEmpty())
			filteredFacets += "," + key;
		else
			filteredFacets += key;

		filteredFacetsList.add(facet);
	
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

	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F resetSorting() {
		sortObj = null;
		this.sortFields = "";
		this.sortDirections = "";
		updateSorting = updateEncodeString = true;
		return (F)this;
	}

	public int resultSize() {
		if (validateQuery()){
			long tmp = System.currentTimeMillis();
			int toreturn = fullTextQuery.getResultSize();
			tmp = System.currentTimeMillis() - tmp;			
			//log("result size in " + tmp +"ms");
			return toreturn;
		}
		else
			return -1;
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
	private <F extends SearchQuery<EntityClass>> F setRangeQuery(Object from, Object to) {
		QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity(entityClass).get();
		luceneQuery = builder.range().onField(searchFields[0]).from(from).to(to).createQuery();
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
		
	public String query(){
			return this.queryText;
	}
	
	@SuppressWarnings("unchecked")
	public <F extends SearchQuery<EntityClass>> F query(String query) {
		queryText = query;
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
	private void log(String a){
		System.out.println(a);
	}
	private boolean validateQuery() {
		long tmp = System.currentTimeMillis();
		if (updateLuceneQuery) {
			if(!createMultiFieldQuery())
				return false;
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		if (updateFullTextQuery) {
			//log("new Full Text Query");

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
}