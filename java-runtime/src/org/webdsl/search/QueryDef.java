package org.webdsl.search;

import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.search.BooleanClause.Occur;

public class QueryDef {

	public boolean isRangeQuery = false, hasParsedQuery = false;
	public Object from, to;
	public String query, parsedQuery;
	public Occur occur;
	public String[] fields;
	public QueryDef parent;
	public List<QueryDef> children = new ArrayList<QueryDef>();	

	public QueryDef(Occur oc, String[] fields){
		this.occur = oc;
		this.fields = fields;
	}
	
	public QueryDef(Occur oc, QueryDef parentQueryDef, String[] fields){
		this.occur = oc;
		this.parent = parentQueryDef;
		this.fields = fields;
		parentQueryDef.children.add(this);
	}
	public void range(Object from, Object to){
		this.isRangeQuery = true;
		this.hasParsedQuery = false;
		this.from = from;
		this.to = to;
	}
	public void query(String query){
		this.isRangeQuery = false;
		this.hasParsedQuery = false;
		this.query = query;
	}
	public void parsedQuery(String parsedQuery){
		this.hasParsedQuery = true;
		this.parsedQuery = parsedQuery;
	}
}
