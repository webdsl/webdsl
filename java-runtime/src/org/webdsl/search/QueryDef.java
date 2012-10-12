package org.webdsl.search;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.Query;

public class QueryDef {

    public enum QueryType {
        TEXT, PHRASE, RANGE, NOQUERY, PARSED_LUCENE, PARSED_STRING, MATCH_ALL, FUZZY, REGEX
    }

    public QueryType queryType = QueryType.NOQUERY;
    public Object min, max;
    public int slop;
    public float similarity;
    public String query;
    public Occur occur;
    public String[] fields;
    public QueryDef parent;
    public Query parsedQuery = null;
    public List<QueryDef> children = new ArrayList<QueryDef>();
    public Map<String, Float> boosts;
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
    public void fuzzyQuery(String query, float similarity){
        this.queryType = QueryType.FUZZY;
        this.query = query;
        this.similarity = similarity;
    }
    public void regexQuery(String regex){
        this.queryType = QueryType.REGEX;
        this.query = regex;
    }
    public void parsedQuery(String parsedQueryString){
        this.queryType = QueryType.PARSED_STRING;
        this.query = parsedQueryString;
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

    public void debug(){
        StringBuffer sb = new StringBuffer();
        sb.append("#######################QUERYDEF DEBUG##########################\n");
        debug(sb, 0);
        sb.append("###############################################################");
        System.out.println(sb.toString());
    }

    public void debug(StringBuffer sb, int ind){
        int newIndent = ind + 1;
        while(ind-- > 1)
            sb.append("|    ");

        if(ind >= 0)
            sb.append("|----");

        sb.append(this.toString());
        sb.append("\n");

        for (QueryDef child : children) {
            child.debug(sb, newIndent);
        }

    }
    public String toString(){
        return "[occur:" + occur + " type:" + queryType + " query:" + query + "]";
    }

//    /**
//     * aborted wip: instead of falling back to query encoded in lucene syntax for complex queries,
//     * we might want to reconstruct the QueryDef objects instead. However, there is a
//     * problem with range queries, because min/max object must also be stringified.
//     */
//    public String asString(){
//        ArrayList<String> list = new ArrayList<String>();
//        serializeToList(list);
//        switch (this.queryType) {
//        case TEXT:
//            return QueryType.TEXT.toString() + "-" + "q";
//            break;
//
//        default:
//            break;
//        }
//    }
//    private void serializeToList(ArrayList<String> list ){
//        list.add(this.queryType.toString());
//
//        switch (this.queryType) {
//        case TEXT:
//            list.add(query);
//            break;
//        case PHRASE:
//            list.add(query);
//            list.add(""+slop);
//            break;
//        case RANGE:
//            list.add(query);
//            list.add(min.toString());
//            list.add(max.toString());
//            this.max = max;
//            this.includeMin = includeMin;
//            this.includeMax = includeMax;
//            break;
//        case NOQUERY:
//            list.add(query);
//            break;
//        case PARSED_LUCENE:
//            list.add(query);
//            break;
//        case PARSED_STRING:
//            list.add(query);
//            break;
//        case MATCH_ALL:
//            list.add(query);
//            break;
//        case FUZZY:
//            list.add(query);
//            break;
//        case REGEX:
//            list.add(query);
//            break;
//        default:
//            break;
//        }
//
//    }
//    private final escape(String q){
//    incomplete method
//    return q.replaceAll("-", "\\h");
//
//    }

}
