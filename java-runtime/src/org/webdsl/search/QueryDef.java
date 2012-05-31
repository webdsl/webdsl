package org.webdsl.search;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.Query;

public class QueryDef {

    public enum QueryType {
        TEXT, PHRASE, RANGE, NOQUERY, PARSED_LUCENE, PARSED_STRING, MATCH_ALL
    }

    public QueryType queryType = QueryType.NOQUERY;
    public Object min, max;
    public int slop;
    public String query, parsedQueryStr;
    public Occur occur;
    public String[] fields;
    public QueryDef parent;
    public Query parsedQuery = null;
    public List<QueryDef> children = new ArrayList<QueryDef>();
    public HashMap<String, Float> boosts;
    public boolean includeMin, includeMax;

    public QueryDef(Occur oc, String[] fields){
        this.occur = oc;
        this.fields = fields;
    }

    public QueryDef(Occur oc, QueryDef parentQueryDef){
        this.occur = oc;
        this.parent = parentQueryDef;
        this.fields = parentQueryDef.fields;
        this.boosts = parentQueryDef.boosts;
        parentQueryDef.children.add(this);
    }
    public void matchAllQuery(){
        this.queryType = QueryType.MATCH_ALL;
    }
    public void range(Object min, Object max, boolean includeMin, boolean includeMax){
        this.queryType = QueryType.RANGE;
        this.min = min;
        this.max = max;
        this.includeMin = includeMin;
        this.includeMax = includeMax;
    }
    public void query(String query){
        this.queryType = QueryType.TEXT;
        this.query = query;
    }
    public void phraseQuery(String query, int slop){
        this.queryType = QueryType.PHRASE;
        this.query = query;
        this.slop = slop;
    }
    public void parsedQuery(String parsedQuery){
        this.queryType = QueryType.PARSED_STRING;
        this.parsedQueryStr = parsedQuery;
    }
    public void parsedQuery(Query q){
        this.queryType = QueryType.PARSED_LUCENE;
        this.parsedQuery = q;

    }
    public void boost(String field, Float boost){
        if ( boosts == null )
            boosts = new HashMap<String, Float>();
        boosts.put( field, boost );
    }
}
