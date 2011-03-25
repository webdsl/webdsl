package org.webdsl.search;

import java.util.ArrayList;

import org.webdsl.WebDSLEntity;

public abstract class SearchQuery{
	
	protected final org.apache.lucene.util.Version luceneVersion = org.apache.lucene.util.Version.LUCENE_30;
	protected int limit = 100;
	protected int offset = 0;
	protected boolean luceneQueryChanged = true;
	protected org.apache.lucene.search.Query luceneQuery = null;
	protected java.util.LinkedHashMap<String, String> constraints = new java.util.LinkedHashMap<String, String>();
	protected org.hibernate.search.FullTextQuery query = null;
	
	protected String searchTerms = "";
	protected String[] searchFields = {};	
	protected org.hibernate.search.FullTextSession fulltextsession;
	protected Class<?> entityClass;
	protected long searchTime = 0;
		
	public SearchQuery (){
	}

	protected void do_setMaxResults (int limit){
		this.limit = limit;		
	}
	protected void do_setFirstResult (int offset){
		this.offset = offset;
	}	
	public void do_setSearchTerms (String terms){
		searchTerms = terms;
		luceneQueryChanged = true;
	}	
	public void do_setSearchFields(java.util.List<String> fields){
		searchFields = (String[]) fields.toArray();
		luceneQueryChanged = true;
	}	
	public void do_addFieldConstraint (String fieldname, String terms)	{
		if (validateQuery()) {
			enableFieldConstraintFilter(fieldname, terms);
		}
		constraints.put(fieldname, terms);		
	}	
	public int getResultSize(){
		if (validateQuery())
			return query.getResultSize();
		else
			return -1;
	}	
	protected boolean validateQuery(){
		if (luceneQueryChanged){
			org.apache.lucene.queryParser.QueryParser parser = new org.apache.lucene.queryParser.MultiFieldQueryParser(luceneVersion, searchFields, new org.apache.lucene.analysis.standard.StandardAnalyzer(org.apache.lucene.util.Version.LUCENE_30));
			try{luceneQuery = parser.parse(searchTerms);} catch (org.apache.lucene.queryParser.ParseException pe){return false;}
			query = fulltextsession.createFullTextQuery(luceneQuery, entityClass);
			applyFieldConstraints();
			luceneQueryChanged = false;
		}
		query.setFirstResult(offset);
		query.setMaxResults(limit);

		return true;
	}	
	private void applyFieldConstraints(){
		for (String field : constraints.keySet())
			enableFieldConstraintFilter(field,constraints.get(field));	
	}	
	private void enableFieldConstraintFilter(String field, String value){
		query.enableFullTextFilter("fieldConstraintFilter").setParameter("field", field).setParameter("value", value);	
	}
	
	public String searchTimeAsString(){
		
		return searchTime + " ms.";
	}
		
	public java.util.List<?> do_getResultList()	{
		if (validateQuery())
	    	return query.list();
	    else
	    	return new java.util.ArrayList<WebDSLEntity>();
	}	
	
}