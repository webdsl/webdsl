package org.webdsl.search;

import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.Query;

public class QueryDef {

    public boolean isRangeQuery = false, hasParsedQuery = false, isPhraseQuery = false;
    public Object from, to;
    public int slop;
    public String query, parsedQueryStr;
    public Occur occur;
    public String[] fields;
    public QueryDef parent;
    public Query parsedQuery = null;
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
        this.isPhraseQuery = false;
        this.from = from;
        this.to = to;
    }
    public void query(String query){
        this.isRangeQuery = false;
        this.hasParsedQuery = false;
        this.isPhraseQuery = false;
        this.query = query;
    }
    public void phraseQuery(String query, int slop){
        this.isRangeQuery = false;
        this.hasParsedQuery = false;
        this.isPhraseQuery = true;
        this.query = query;
        this.slop = slop;
    }
    public void parsedQuery(String parsedQuery){
        this.hasParsedQuery = true;
        this.parsedQueryStr = parsedQuery;
    }
    public void parsedQuery(Query q){
        this.hasParsedQuery = true;
        this.parsedQuery = q;

    }
}
