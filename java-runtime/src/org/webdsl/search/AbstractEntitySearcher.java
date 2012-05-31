package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.queryParser.QueryParser.Operator;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.Explanation;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.similar.MoreLikeThis;
import org.apache.lucene.util.Version;
import org.hibernate.search.FullTextQuery;
import org.hibernate.search.FullTextSession;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.hibernate.search.query.dsl.RangeMatchingContext.FromRangeContext;
import org.hibernate.search.query.dsl.RangeTerminationExcludable;
import org.hibernate.search.query.dsl.impl.WebDSLFacetTool;
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetingRequest;
import org.webdsl.WebDSLEntity;
import org.webdsl.search.QueryDef.QueryType;

import com.browseengine.bobo.api.BoboBrowser;
import com.browseengine.bobo.api.BoboIndexReader;
import com.browseengine.bobo.api.Browsable;
import com.browseengine.bobo.api.BrowseException;
import com.browseengine.bobo.api.BrowseFacet;
import com.browseengine.bobo.api.BrowseRequest;
import com.browseengine.bobo.api.BrowseResult;
import com.browseengine.bobo.api.FacetAccessible;
import com.browseengine.bobo.api.FacetSpec;
import com.browseengine.bobo.api.FacetSpec.FacetSortSpec;
import com.browseengine.bobo.facets.FacetHandler;
import com.browseengine.bobo.facets.impl.MultiValueFacetHandler;

public abstract class AbstractEntitySearcher<EntityClass extends WebDSLEntity, F extends AbstractEntitySearcher<?,?>> {

    protected static final Version LUCENEVERSION         = Version.LUCENE_33;
    protected static final int LIMIT                     = 50;
    protected static final int OFFSET                    = 0;
    protected static final Operator OP                   = Operator.OR;
    protected static final boolean ALLOWLUCENESYNTAX     = true;

    protected int limit = LIMIT;
    protected int offset = OFFSET;
    protected Operator defaultOperator = OP;

    protected boolean updateFullTextQuery, updateSorting, updateFacets, updateNamespaceConstraint, updateFieldConstraints, updateLuceneQuery = true, updateParamMap = true, updateHighlightQuery = true;
    protected boolean allowLuceneSyntax = ALLOWLUCENESYNTAX, searchFieldsChanged = false, updateBoboBrowseResult = true;

    protected HashMap<String, String> fieldConstraints;
    protected HashMap<String, Facet> facetMap;
    protected HashMap<String, String> rangeFacetRequests;
    protected HashMap<String, Integer> discreteFacetRequests;
    protected Map<String, String> paramMap;
    private BrowseResult boboBrowseResult;

    protected List<WebDSLFacet> filteredFacetsList = new ArrayList<WebDSLFacet>();

    protected Query luceneQueryNoFacetFilters, highlightQuery, luceneQuery = null;
    protected FullTextQuery fullTextQuery = null;
    protected FullTextSession fullTextSession;

    protected String[] searchFields, defaultSearchFields, mltSearchFields, untokenizedFields;

    protected String sortFields = "", sortDirections = "";
    protected String moreLikeThisParams = "";

    protected QueryDef rootQD, currentQD, parentQD;

    protected String namespaceConstraint = "";

    protected Analyzer analyzer, highlightAnalyzer;
    protected Class<?> entityClass;
    protected long searchTime = 0;
    protected Sort sortObj;

    public AbstractEntitySearcher() {
    }

    @SuppressWarnings("unchecked")
    public F addFieldFilter( String fieldname, String terms ) {
        if ( fieldConstraints == null )
            fieldConstraints = new HashMap<String, String>();

        fieldConstraints.put( fieldname, terms );
        updateFieldConstraints = updateParamMap = true;
        return ( F ) this;
    }

    public List<String> getFilteredFields(){
        List<String> toReturn = new ArrayList<String>();
        if ( fieldConstraints != null )
            toReturn.addAll(fieldConstraints.keySet());
        return toReturn;
    }

    public String getFieldFilterValue( String fieldname ) {
        if ( fieldConstraints == null )
            return null;
        return fieldConstraints.get( fieldname );
    }
    @SuppressWarnings("unchecked")
    public F removeFieldFilter( String fieldname ){
        if(fieldConstraints != null && !fieldConstraints.remove(fieldname).isEmpty())
           updateFieldConstraints = updateParamMap = true;
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F clearFieldFilters(){
        if(fieldConstraints != null && fieldConstraints.size() > 0){
            fieldConstraints.clear();
            updateFieldConstraints = updateParamMap = true;
        }
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F allowLuceneSyntax( boolean b ) {
        if ( this.allowLuceneSyntax != b ) {
            this.allowLuceneSyntax = b;
            updateLuceneQuery = updateParamMap = true;
        }
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F must() {
        addSubQuery( Occur.MUST );
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F mustNot() {
        addSubQuery( Occur.MUST_NOT );
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F should() {
        addSubQuery( Occur.SHOULD );
        return ( F ) this;
    }
    private final void addSubQuery( Occur oc ) {
        currentQD = new QueryDef( oc, parentQD);
    }

    @SuppressWarnings("unchecked")
    public F startMustClause() {
        addClause( Occur.MUST );
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F startMustNotClause() {
        addClause( Occur.MUST_NOT );
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F startShouldClause() {
        addClause( Occur.SHOULD );
        return ( F ) this;
    }
    @SuppressWarnings("unchecked")
    public F endClause() {
        parentQD = ( parentQD == rootQD ) ? parentQD : parentQD.parent;
        return ( F ) this;
    }
    private final void addClause( Occur oc ) {
        currentQD = new QueryDef( oc, parentQD );
        parentQD = currentQD;
    }

    private void applyFacets() {
        if ( facetMap == null )
            facetMap = new HashMap<String, Facet>();
        String key;

        if ( filteredFacetsList.isEmpty() ) {
            luceneQuery = luceneQueryNoFacetFilters;
            return;
        }

        BooleanQuery shouldFacetQuery = new BooleanQuery();
        BooleanQuery newQuery = new BooleanQuery();

        HashMap<String, BooleanQuery> shouldFacetQueryMap = new HashMap<String, BooleanQuery>( 10 );

        for( WebDSLFacet facet : filteredFacetsList ) {
            if ( rangeFacetRequests != null && rangeFacetRequests.containsKey( facet.getFieldName() )) {
                key = facet.getFieldName() + "-" + facet.getValue();
                Facet actualFacet = facetMap.get( key );
                if ( actualFacet == null ) {
                    // Facets are not yet retrieved during this object's life cycle, probably this is a search query reconstructed from param map.
                    getFacets( facet.getFieldName() );
                    actualFacet = facetMap.get( key );
                }

                if ( actualFacet == null ) {
                    log("Facet '" + key + "'to narrow not found, should not happen!");
                    continue;
                }
                if ( facet.occur.equals( Occur.SHOULD )) {
                    shouldFacetQuery = shouldFacetQueryMap.get( facet.fieldName );
                    if ( shouldFacetQuery == null ) {
                        shouldFacetQuery = new BooleanQuery();
                        shouldFacetQueryMap.put( facet.fieldName, shouldFacetQuery);
                    }
                    shouldFacetQuery.add( actualFacet.getFacetQuery(), facet.occur );
                } else {
                    newQuery.add( actualFacet.getFacetQuery(), facet.occur );
                }
            } else {
                if ( facet.occur.equals( Occur.SHOULD )) {
                    shouldFacetQuery = shouldFacetQueryMap.get( facet.fieldName );
                    if ( shouldFacetQuery == null ) {
                        shouldFacetQuery = new BooleanQuery();
                        shouldFacetQueryMap.put( facet.fieldName, shouldFacetQuery);
                    }
                    shouldFacetQuery.add( new TermQuery( new Term( facet.getFieldName(), facet.getValue() ) ), facet.occur );
                } else {
                    newQuery.add( new TermQuery( new Term( facet.getFieldName(), facet.getValue() ) ), facet.occur );
                }
            }
        }

        for (BooleanQuery bq : shouldFacetQueryMap.values()) {
            newQuery.add( bq, Occur.MUST );
        }
        newQuery.add( luceneQueryNoFacetFilters, Occur.MUST );

        luceneQuery = newQuery;
    }

    private void applyFieldConstraints() {
        int cnt = 0;
        for ( String field : fieldConstraints.keySet() ) {
            enableFieldConstraintFilter( field, fieldConstraints.get( field ), cnt );
            cnt++;
        }
    }

    private void applyNamespaceConstraint() {
        fullTextQuery.enableFullTextFilter("namespaceConstraintFilter")
        .setParameter( "namespace", namespaceConstraint );
    }

    @SuppressWarnings("unchecked")
    public F boost( String field, Float boost ) {

        updateLuceneQuery = updateParamMap = true;
        return ( F ) this;
    }

	public void closeReader(IndexReader reader){
		if(reader != null)
		getFullTextSession().getSearchFactory().closeIndexReader(reader);
	}

    private final QueryParser getQueryParser(QueryDef qd){
        QueryParser toReturn;
        if ( qd.boosts == null || qd.boosts.isEmpty() )
            toReturn = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer );
        else
            toReturn = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer, qd.boosts );
        toReturn.setDefaultOperator( defaultOperator );

        return toReturn;
    }

    private Query createMatchAllQuery(){
        return getFullTextSession().getSearchFactory()
                .buildQueryBuilder().forEntity( entityClass ).get().all()
                .createQuery();
    }

    private Query createMultiFieldPhraseQuery ( QueryDef qd) throws ParseException {
        return getQueryParser(qd).parse( "\"" + SpecialMultiFieldQueryParser.escape( qd.query ) + "\"~" + qd.slop);
    }

    private Query createMultiFieldQuery( QueryDef qd ) throws ParseException {
        if ( allowLuceneSyntax )
            return getQueryParser(qd).parse( qd.query );
        else
            return getQueryParser(qd).parse( SpecialMultiFieldQueryParser.escape( qd.query ));
    }

    private static String decodeValue( String str ) {
        return str.replaceAll("\\\\c",",").replaceAll("\\\\\\\\ ", "\\\\");
    }

    @SuppressWarnings("unchecked")
    public F defaultAnd() {
        if (!defaultOperator.equals( Operator.AND )) {
            defaultOperator = Operator.AND;
            updateLuceneQuery = updateParamMap = true;
        }
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F defaultOr() {
        if (!defaultOperator.equals( Operator.OR )) {
            defaultOperator = Operator.OR;
            updateLuceneQuery = updateParamMap = true;
        }
        return ( F ) this;
    }

    private void enableFieldConstraintFilter( String field, String value, int cnt ) {
        if ( cnt < 5 ) {
        fullTextQuery.enableFullTextFilter("fieldConstraintFilter" + cnt )
            .setParameter("field", field )
            .setParameter("value", value )
            .setParameter("analyzer", analyzer )
            .setParameter("allowLuceneSyntax", allowLuceneSyntax );
        } else {
            log("At most 5 field filters can be enabled. Filter on field:'"+ field + "', value:'" + value + "' is ignored!.");
        }
    }

    public final String asString(){
        return utils.URLFilter.paramMapToPostParamsEncoding(this.toParamMap());
    }

    public static AbstractEntitySearcher<?,?> fromString(String str){
        return fromParamMap(utils.URLFilter.URLEncodingToParamMap(str));
    }

    public final Map<String,String> toParamMap() {
        if (!updateParamMap ) {
            return paramMap;
        }

        paramMap = new HashMap<String, String>();
        StringBuilder sb;

        paramMap.put("type", entityClass.getSimpleName());

        //search fields
        if ( searchFieldsChanged ) {
        sb = new StringBuilder();
        for( int cnt = 0 ; cnt < searchFields.length-1; cnt++ )
            sb.append( searchFields[cnt] + "," );
        sb.append( searchFields[searchFields.length-1] );
        paramMap.put( "sf", sb.toString() );
        }
        //search terms
        QueryDef usableRootQD = rootQD;
        if ( rootQD.queryType.equals(QueryType.NOQUERY) && rootQD.children.size() == 1 && rootQD.children.get(0).occur.equals( Occur.SHOULD ) )
            usableRootQD = rootQD.children.get(0);

        if( usableRootQD.children.isEmpty() ) {
            switch (usableRootQD.queryType) {
            case TEXT:
                paramMap.put( "q", usableRootQD.query );
                break;
            case PHRASE:
                paramMap.put( "pq", usableRootQD.query );
                paramMap.put( "sl", String.valueOf( usableRootQD.slop ) );
                break;
            default:
                paramMap.put( "lq", getLuceneQueryAsString() );
                break;
            }
        } else {
            paramMap.put( "lq", getLuceneQueryAsString() );
        }

        //field boosts (are encoded in lucene query if lucene query is used for serialization)
        if (!paramMap.containsKey("lq")){
            if ( usableRootQD.boosts !=null && !usableRootQD.boosts.isEmpty() ) {
                sb = new StringBuilder();
                for ( String field : usableRootQD.boosts.keySet() ) sb.append( field + ",");
                paramMap.put("bf", sb.toString() );
                sb = new StringBuilder();
                for ( Float value : usableRootQD.boosts.values() ) sb.append( value + ",");
                paramMap.put("bv", sb.toString() );
            }
        }

        //default operator
        if (!OP.equals( defaultOperator ))
            paramMap.put("op", defaultOperator.toString() );
        //constraint fields, values
        if ( fieldConstraints!=null && !fieldConstraints.isEmpty() ) {
            sb = new StringBuilder();
            for ( String field : fieldConstraints.keySet() ) sb.append( field + ",");
            paramMap.put("cf", sb.toString() );

            sb = new StringBuilder();
            for ( String value : fieldConstraints.values() ) sb.append( value + ",");
            paramMap.put("cv", sb.toString() );
        }
        //range facet fields, params
        if ( rangeFacetRequests !=null && !rangeFacetRequests.isEmpty() ) {
            sb = new StringBuilder();
            for( String field : rangeFacetRequests.keySet() ) sb.append( field + ",");
            paramMap.put("rff", sb.toString() );

            sb = new StringBuilder();
            for( String param : rangeFacetRequests.values() ) sb.append( encodeValue( param ) + ",");
            paramMap.put("rfp", sb.toString() );
        }
        //discrete facet fields, params
        if ( discreteFacetRequests !=null && !discreteFacetRequests.isEmpty() ) {
            sb = new StringBuilder();
            for( String field : discreteFacetRequests.keySet() ) sb.append( field + ",");
            paramMap.put("dff", sb.toString() );

            sb = new StringBuilder();
            for( Integer param : discreteFacetRequests.values() ) sb.append( param + ",");
            paramMap.put("dfp", sb.toString() );

        }
        //limit
        if ( LIMIT != limit )
            paramMap.put("lim", String.valueOf( limit ));
        //offset
        if ( OFFSET != offset )
            paramMap.put("offset", String.valueOf( offset ));
        //narrowed facets
        if (!filteredFacetsList.isEmpty() ) {
            sb = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            StringBuilder sb3 = new StringBuilder();
            StringBuilder sb4 = new StringBuilder();
            for( WebDSLFacet f : filteredFacetsList ) {
                sb.append( f.fieldName + ",");
                sb2.append( encodeValue( f.value ) + ",");
                sb3.append( f.occur.name() + ",");
                sb4.append( f.count + ",");
            }
            paramMap.put("ffld", sb.toString() );
            paramMap.put("fvl", sb2.toString() );
            paramMap.put("focc", sb3.toString() );
            paramMap.put("fcnt", sb4.toString() );
        }

        //sort fields
        if (!sortFields.isEmpty() )
            paramMap.put("sortby", sortFields );

        //sort directions
        if (!sortDirections.isEmpty() )
            paramMap.put("dirs", sortDirections );

        //more like this
        if (!moreLikeThisParams.isEmpty() )
            paramMap.put("mlt", moreLikeThisParams );

        //allow lucene syntax?
        if ( ALLOWLUCENESYNTAX != allowLuceneSyntax )
            paramMap.put("allowlcn", String.valueOf( allowLuceneSyntax ));

        //namespace constraint?
        if (!namespaceConstraint.isEmpty() )
            paramMap.put("ns", namespaceConstraint );

        updateParamMap = false;
        return paramMap;
    }

    public static AbstractEntitySearcher<?,?> fromParamMap( Map<String,String> paramMap ) {
        AbstractEntitySearcher<?, ?> searcher = null;
        try {
            String key, value;
            searcher = (AbstractEntitySearcher<?, ?>) Class.forName("webdsl.generated.search."+ paramMap.get("type")+"Searcher").newInstance();
            for ( Map.Entry<String,String> e : paramMap.entrySet() ) {
                key = e.getKey();
                value = e.getValue();
                if("type".equals( key )){
                    continue;
                } else if ("sf".equals( key )) {
                    // search fields
                    searcher.fields( new ArrayList<String>( Arrays.asList( value.split(",") )) );
                } else if ("q".equals( key )) {
                    //ordinary query
                    searcher.query( value );
                } else if ("lq".equals( key )) {
                    //search query, lucene string representation
                    searcher.currentQD.parsedQuery( value );
                } else if ("pq".equals( key )) {
                    //phrase query
                    searcher.phraseQuery( value, Integer.parseInt( paramMap.get( "sl" ) ) );
                } else if ("op".equals( key ) && value.equals("AND") ) {
                    //change default operator to AND
                    searcher.defaultAnd();
                } else if ("cf".equals( key )) {
                    //constraint fields, values
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("cv").split(",");
                    for( int i=0; i < a1.length; i++)
                        searcher.addFieldFilter( a1[i], a2[i]);
                } else if ("rff".equals( key )) {
                    //range facet fields, params
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("rfp").split(",");
                    String field;
                    String param;
                    searcher.rangeFacetRequests = new HashMap<String, String>();
                    for( int i=0; i < a1.length; i++) {
                        field = a1[i];
                        param = decodeValue( a2[i]);
                        searcher.enableFaceting( field, param );
                    }

                } else if ("dff".equals( key )) {
                    //discrete facet fields, params
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("dfp").split(",");
                    String field;
                    int param;
                    searcher.discreteFacetRequests = new HashMap<String, Integer>();
                    for( int i=0; i < a1.length; i++) {
                        field = a1[i];
                        param = Integer.parseInt( a2[i]);
                        searcher.enableFaceting( field, param );
                    }

                } else if ("lim".equals( key )) {
                    //limit
                    searcher.setLimit( Integer.parseInt( value ));
                } else if ("offset".equals( key )) {
                    //offset
                    searcher.setOffset( Integer.parseInt( value ));
                } else if ("bf".equals( key )) {
                    //boost fields, values
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("bv").split(",");
                    for( int i=0; i < a1.length; i++)
                        searcher.boost( a1[i], Float.parseFloat( a2[i]) );
                } else if ("ffld".equals( key )) {
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("fvl").split(",");
                    String[] a3 = paramMap.get("focc").split(",");
                    String[] a4 = paramMap.get("fcnt").split(",");
                    for( int i=0; i < a1.length; i++) {
                        searcher.addFacetSelection( new WebDSLFacet( a1[i], decodeValue( a2[i] ), Occur.valueOf( a3[i] ), Integer.parseInt( a4[i] ) ) );
                    }
                } else if ("sortby".equals( key )) {
                    //sort fields, directions
                    String[] a1 = value.split(",");
                    String[] a2 = paramMap.get("dirs").split(",");
                    for( int i=0; i < a1.length; i++)
                        searcher.sort( a1[i], Boolean.getBoolean( a2[i]) );
                } else if ("mlt".equals( key )) {
                    //more like this
                    String[] a1 = value.split(",");
                    searcher.moreLikeThis( a1[0], Integer.parseInt( a1[1]), Integer.parseInt( a1[2]), Integer.parseInt( a1[3]), Integer.parseInt( a1[4]), Integer.parseInt( a1[5]), Integer.parseInt( a1[6]) );
                } else if ("allowlcn".equals( key )) {
                    // allow Lucene syntax?
                    searcher.allowLuceneSyntax( Boolean.parseBoolean( value ) );
                } else if ("ns".equals( key )) {
                    //namespace
                    searcher.setNamespace( value );
                }
            }
        } catch ( Exception e ) {
            e.printStackTrace();
            log("Error during entity searcher decoding!");
        }

        searcher.paramMap = paramMap;
        searcher.updateParamMap = false;
        return searcher;

    }

    private String encodeValue( String str ) {
        return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll(",", "\\\\c");
    }

    @SuppressWarnings("unchecked")
    public F enableFaceting( String field, Integer topN ) {
        if ( discreteFacetRequests == null )
            discreteFacetRequests = new HashMap<String, Integer>();

        if ( topN == 0 )
            discreteFacetRequests.remove( field );
        else if( topN != discreteFacetRequests.put( field, topN ) )
            updateBoboBrowseResult = true;

        updateParamMap = true;

        return ( F ) this;
    }

    // example ranges: "[ TO 100 ],{100 TO 201}[201 TO ]"   "[-200 TO -100 ][-100 TO 0 ][ 0 TO ]"
    // [ and ] mean include in min/max, { and } mean exclude in min/max
    // Bug on numeric fields: http://opensource.atlassian.com/projects/hibernate/browse/HSEARCH-770
    // Therefore using custom Hibernate Search jar, but still includes entities with null values on the faceting field in counts :(
    @SuppressWarnings("unchecked")
    public F enableFaceting( String field, String rangesAsString ) {
        if ( rangeFacetRequests == null )
            rangeFacetRequests = new HashMap<String, String>();

        rangeFacetRequests.put( field, rangesAsString );
        updateParamMap = true;

        return ( F ) this;
    }

    private void enableFacets() {
        for( Map.Entry<String, String> facetEntry : rangeFacetRequests.entrySet() ) {
            if ( facetEntry.getValue().contains(" TO ") )
                this.enableRangeFacet( facetEntry.getKey(), facetEntry.getValue() );
            // now using bobo for discrete facets
            //else
                //this.enableDiscreteFacet( facetEntry.getKey(), Integer.parseInt( facetEntry.getValue() ));

        }
    }

    private void enableRangeFacet( String field, String rangesAsString ) {
        FacetingRequest facetReq  = WebDSLFacetTool.toFacetingRequest( field, rangesAsString, entityClass, fieldType( field ), getFullTextSession() );

        fullTextQuery.getFacetManager().enableFaceting( facetReq );
    }

    public List<WebDSLFacet> getFacetsWithinSelection( String field ) {
        return getFacets( field, false );
    }

    public List<WebDSLFacet> getFacets( String field ) {
        return getFacets( field, true );
    }

    private List<WebDSLFacet> getFacets( String field, boolean ignoreFacetSelection ) {

        if (discreteFacetRequests != null && discreteFacetRequests.containsKey( field )) {
            return getBoboFacets( field, ignoreFacetSelection );
        } else if (rangeFacetRequests != null && rangeFacetRequests.containsKey( field )) {
            String facetName = WebDSLFacetTool.facetName( field );
            List<Facet> facets;
            if ( validateQuery() ) {
                facets = fullTextQuery.getFacetManager().getFacets( facetName );
                //If no facets are returned, facets are probably not enabled yet
                if ( facets.isEmpty() ) {
                    enableFacets();
                    facets = fullTextQuery.getFacetManager().getFacets( facetName );
                }
            }
            else
                return new ArrayList<WebDSLFacet>();

            return toWebDSLFacets( facets );
        } else
            return new ArrayList<WebDSLFacet>();
    }

    public List<WebDSLFacet> getFacetSelection() {
        return filteredFacetsList;
    }

    public List<WebDSLFacet> getFacetSelection( String field ){
        List<WebDSLFacet> toReturn = new ArrayList<WebDSLFacet>();
        for (WebDSLFacet webDSLFacet : filteredFacetsList) {
            if (webDSLFacet.fieldName.equals(field))
                toReturn.add(webDSLFacet);
        }
        return toReturn;
    }

    @SuppressWarnings("unchecked")
    public F addFacetSelection( WebDSLFacet facet ) {
        //if already narrowed on this facet, don't add it again
        //A facet already appears in the list if field and value are equal
        if ( filteredFacetsList.contains( facet )){
            return ( F ) this;
        }

        facet.isSelected = true;
        filteredFacetsList.add( facet );

        updateFacets = updateParamMap = true;
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F addFacetSelection( List<WebDSLFacet> facets ) {
        for (WebDSLFacet f : facets) {
            addFacetSelection(f);
        }
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F removeFacetSelection( WebDSLFacet f ) {
        filteredFacetsList.remove( f );
        updateFacets = updateParamMap = true;
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F clearFacetSelection( ) {
        filteredFacetsList.clear();
        updateFacets = updateParamMap = true;
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F clearFacetSelection( String field ) {
        for(WebDSLFacet f : filteredFacetsList){
            if (f.fieldName.equals(field))
                removeFacetSelection( f );
        }
        return ( F ) this;
    }

    public F defaultFields(){
        return ( F ) fields( new ArrayList<String>( Arrays.asList( defaultSearchFields ) ) );
    }

    public F field( String field ) {
        return ( F ) fields( new ArrayList<String>( Arrays.asList( field ) ) );
    }

    @SuppressWarnings("unchecked")
    public F fields( List<String> fields ) {
        searchFields = fields.toArray( new String[fields.size()]);
        //no need to clone searchFields, because variable searchFields is only reassigned and never modified.
        currentQD.fields = searchFields;

        //Untokenized fields should be excluded from more like this queries
        for ( int i = 0; i < untokenizedFields.length; i++)
            fields.remove( untokenizedFields[i]);
        mltSearchFields = fields.toArray( new String[fields.size()]);

        searchFieldsChanged = updateLuceneQuery = updateParamMap = true;
        return ( F ) this;
    }

    public List<String> getFields(){
        return Arrays.asList(currentQD.fields);
    }

    public abstract Class<?> fieldType( String field );

    public abstract boolean instanceOf( String s );

    public Analyzer getAnalyzer(){
        return analyzer;
    }

    @SuppressWarnings("unchecked")
    public F setNamespace( String namespace ) {
        if (!namespaceConstraint.equals( namespace )) {
            //first remove old namespace filter if set
            if (!namespaceConstraint.isEmpty() )
                fullTextQuery.disableFullTextFilter("namespaceConstraintFilter");
        }
        else {
            return ( F ) this;
        }
        namespaceConstraint = namespace;
        updateNamespaceConstraint = updateParamMap = true;
        return ( F ) this;

    }

    @SuppressWarnings("unchecked")
    public F removeNamespace() {
        fullTextQuery.disableFullTextFilter("namespaceConstraintFilter");
        namespaceConstraint = "";
        updateParamMap = true;
        return ( F ) this;

    }

    public String getNameSpace() {
        return namespaceConstraint;
    }

    @SuppressWarnings("unchecked")
    public F setOffset( int offset ) {
        this.offset = offset;
        updateParamMap = true;
        return ( F ) this;
    }

    public int getOffset(){
        return this.offset;
    }

    protected abstract FullTextSession getFullTextSession ();

    public IndexReader getReader() {
        SearchFactory searchFactory = getFullTextSession().getSearchFactory();
        return searchFactory.openIndexReader(entityClass);
    }

    public static String escapeQuery( String query ) {
        return QueryParser.escape( query );
    }

    public String highlight( String field, String toHighLight ) {
        return highlight(field, toHighLight, "<B>", "</B>", 3, 80, " ...");
    }

    public String highlight( String field, String toHighLight, String preTag, String postTag ) {
        return highlight(field, toHighLight, preTag, postTag, 3, 80, " ...");

    }

    public String highlight ( String field, String toHighLight, String preTag, String postTag, int fragments, int fragmentLength, String separator ) {
        validateQuery();
        IndexReader ir = getReader();
        try{
          return ResultHighlighter.highlight( ir, highlightAnalyzer, luceneQueryNoFacetFilters, field, toHighLight, preTag, postTag, fragments, fragmentLength, separator );
        } finally{
            closeReader(ir);
        }
    }

    public List<Float> scores(){
        List<Float> toReturn = new ArrayList<Float>();
        validateQuery();
        fullTextQuery.setProjection(FullTextQuery.SCORE);
        for (Object obj : fullTextQuery.list()) {
            toReturn.add( (Float) ((Object[]) obj)[0] );
        };
        fullTextQuery.setProjection(FullTextQuery.THIS);
        return toReturn;

    }

    //Expensive, but useful for debugging search behaviour, returns Lucene explanations in html (use rawoutput to display them)
    public List<String> explanations(){
        List<String> toReturn = new ArrayList<String>();
        validateQuery();
        fullTextQuery.setProjection(FullTextQuery.EXPLANATION);
        for (Object obj : fullTextQuery.list()) {
            toReturn.add( ((Explanation) ((Object[]) obj)[0]).toHtml() );
        };
        fullTextQuery.setProjection(FullTextQuery.THIS);
        return toReturn;

    }

    @SuppressWarnings("unchecked")
    public List<EntityClass> results() {
        try {
            searchTime = System.currentTimeMillis();
            if ( validateQuery() ) {
                List<EntityClass> toReturn = fullTextQuery.list();
                searchTime = System.currentTimeMillis() - searchTime;
                //log("got result list in " + searchTime +"ms");
                return toReturn;
            }
        } catch( Exception ex ) {
            log("ERROR WHILE LISTING SEARCH RESULTS");
            ex.printStackTrace();
        }
        //Something went wrong
        searchTime = 0;
        return new ArrayList<EntityClass>();
    }

    @SuppressWarnings("unchecked")
    public F setLimit( int limit ) {
        this.limit = limit;
        updateParamMap = true;
        return ( F ) this;
    }

    public int getLimit(){
        return this.limit;
    }

    public F moreLikeThis( String likeText ) {
        int minWordLen = 5, maxWordLen = 30, minDocFreq = 1, minTermFreq = 3, maxQueryTerms = 6, maxDocFreqPct = 100;
        return ( F ) moreLikeThis( likeText, minWordLen, maxWordLen, minDocFreq, maxDocFreqPct,
                minTermFreq, maxQueryTerms );
    }

    @SuppressWarnings("unchecked")
    public F moreLikeThis(
            String likeText, int minWordLen, int maxWordLen, int minDocFreq, int maxDocFreqPct, int minTermFreq, int maxQueryTerms ) {

        moreLikeThisParams = likeText + "," + minWordLen + "," + maxWordLen + "," + minDocFreq + "," + maxDocFreqPct + "," + minTermFreq + "," + maxQueryTerms;

        IndexReader ir = getReader();
        MoreLikeThis mlt = new MoreLikeThis( ir );
        mlt.setFieldNames( mltSearchFields );
        mlt.setAnalyzer( analyzer );
        mlt.setMinWordLen( minWordLen );
        mlt.setMaxWordLen( maxWordLen );
        mlt.setMaxDocFreqPct( maxDocFreqPct );
        mlt.setMinDocFreq( minDocFreq );
        mlt.setMinTermFreq( minTermFreq );
        mlt.setMaxQueryTerms( maxQueryTerms );

        try {
            currentQD.parsedQuery( mlt.like( new StringReader( likeText ) ));
        } catch ( IOException e ) {
            e.printStackTrace();
        } finally {
            closeReader( ir );
        }
        updateLuceneQuery = true;
        return ( F ) this;
    }

//    public F rangeQuery( Date from, Date to, boolean includeMin, boolean includeMax) {
//        return ( F ) range( from, to, includeMin, includeMax );
//    }
//
//    public F rangeQuery( Float from, Float to, boolean includeMin, boolean includeMax ) {
//        return ( F ) range( from, to, includeMin, includeMax );
//    }
//
//    public F rangeQuery( int from, int to, boolean includeMin, boolean includeMax ) {
//        return ( F ) range( from, to, includeMin, includeMax );
//    }
//
//    public F rangeQuery( String from, String to, boolean includeMin, boolean includeMax ) {
//        return ( F ) range( from, to, includeMin, includeMax );
//    }

    public int count() {
        try {
            if ( validateQuery() ) {
                return fullTextQuery.getResultSize();
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }
        //Something went wrong
        return 0;
    }

    public String searchTime() {
        return searchTime + " ms";
    }

    public int searchTimeMillis() {
        return ( int ) this.searchTime;
    }

    public float searchTimeSeconds() {
        return ( float ) ( this.searchTime / 1000 );
    }

    public F rangeQuery( Object min, Object max ) {
        //min and max are included by default
        return rangeQuery(min, max, true, true);
    }

    @SuppressWarnings("unchecked")
    public F rangeQuery( Object min, Object max, boolean includeMin, boolean includeMax ) {
        currentQD.range( min, max, includeMin, includeMax );

        updateLuceneQuery = updateFullTextQuery = updateParamMap = true;
        return ( F ) this;
    }

    private void sort( String field, boolean reverse ) {

        if ( sortObj == null ) {
            this.sortFields = field;
            this.sortDirections = String.valueOf( reverse );
            sortObj = new Sort();
            sortObj.setSort( new SortField[0]);
        }
        else {
            //If sort field already exists, don't do anything
            if ( sortFields.matches("(^|.*,)" + field + "(,.*|$)") ) {
                return;
            }
            this.sortFields += "," + field;
            this.sortDirections += "," + String.valueOf( reverse );
        }
        SortField[] sfs = sortObj.getSort();
        SortField[] newSfs = Arrays.copyOf( sfs, sfs.length+1 );
        newSfs[sfs.length] = new SortField( field, sortType( field ), reverse );
        sortObj.setSort( newSfs );

        updateSorting = updateParamMap = true;
    }

    @SuppressWarnings("unchecked")
    public F sortAsc( String field ) {
        sort( field, false );
        return ( F )this;
    }
    @SuppressWarnings("unchecked")
    public F sortDesc( String field ) {
        sort( field, true );
        return ( F )this;
    }

    @SuppressWarnings("unchecked")
    public F clearSorting() {
        this.sortFields = "";
        this.sortDirections = "";
        sortObj = new Sort();
        sortObj.setSort( new SortField[0]);
        updateSorting = updateParamMap = true;

        return ( F )this;
    }

    public int sortType( String field ) {
        Class<?> tp = fieldType( field );
        if ( tp.isAssignableFrom( String.class ))
            return SortField.STRING;
        if ( tp.isAssignableFrom( Integer.class ))
            return SortField.INT;
        if ( tp.isAssignableFrom( Float.class ))
            return SortField.FLOAT;
        else
            return SortField.STRING;
    }

    public abstract F reset();

    public String getQuery() {
        if ( rootQD.children.size() < 1 ) {
            return rootQD.query;
        } else if ( rootQD.children.size() == 1 ) {
            if ( ( rootQD.query == null || rootQD.query.isEmpty() ) &&
                rootQD.children.get( 0 ).children.size() < 1 ) {
                return rootQD.children.get( 0 ).query;
            }
        }

        validateQuery();
        return luceneQuery.toString();

    }

    @SuppressWarnings("unchecked")
    public F query( String query ) {
        currentQD.query( query );
        updateLuceneQuery = updateParamMap = true;
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F phraseQuery( String query, int slop ) {
        currentQD.phraseQuery( query, slop );
        updateLuceneQuery = updateParamMap = true;
        return ( F ) this;
    }

    @SuppressWarnings("unchecked")
    public F matchAllQuery() {
        currentQD.matchAllQuery();
        updateLuceneQuery = updateParamMap = true;
        return ( F ) this;
    }

    private ArrayList<WebDSLFacet> toWebDSLFacets( List<Facet> facets ) {
        String key;
        ArrayList<WebDSLFacet> webdslFacets = new ArrayList<WebDSLFacet>();

        if ( facetMap == null )
            facetMap = new HashMap<String, Facet>();

        WebDSLFacet toAdd;
        for ( Facet facet : facets ) {
            key = facet.getFieldName() + "-" + facet.getValue();
            if (!facetMap.containsKey( key ))
                facetMap.put( key, facet );
            toAdd = new WebDSLFacet( facet );
            toAdd.isSelected = filteredFacetsList.contains( toAdd );
            webdslFacets.add( toAdd );
        }
        return webdslFacets;
    }
    protected static void log( String a ) {
        System.out.println( a );
    }

    private String getLuceneQueryAsString() {
        if ( updateLuceneQuery ) {
            try {
                luceneQuery = createLuceneQuery( rootQD );
                luceneQueryNoFacetFilters = luceneQuery;
            } catch ( ParseException e ) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return luceneQuery.toString("Error occured during query parsing");
            }
            updateLuceneQuery = false;
            updateHighlightQuery = updateBoboBrowseResult = updateFullTextQuery = updateFacets = true;
        }
        return luceneQueryNoFacetFilters.toString();
    }

    private Query getParsedQuery( QueryDef qd ) throws ParseException {
       return new QueryParser( LUCENEVERSION, "", this.analyzer ).parse( qd.parsedQueryStr );
    }

    public String luceneQuery() {
        validateQuery();
        return luceneQuery.toString();
    }

    private boolean validateQuery() {
//        long tmp = System.currentTimeMillis();
        if ( updateLuceneQuery ) {
            try {
                luceneQuery = createLuceneQuery( rootQD );
                luceneQueryNoFacetFilters = luceneQuery;
            } catch ( ParseException e ) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return false;
            }
//            log("LUCENE QUERY: " + luceneQuery.toString() );
            updateLuceneQuery = false;
            updateHighlightQuery = updateBoboBrowseResult = updateFullTextQuery = updateFacets = true;
        }
        if ( updateFacets ) {
            updateFacets = false;
            applyFacets();
            updateBoboBrowseResult = updateFullTextQuery = true;
        }
        if ( updateFullTextQuery ) {
            fullTextQuery = getFullTextSession().createFullTextQuery( luceneQuery, entityClass );
            updateFullTextQuery = false;
            updateNamespaceConstraint = updateFieldConstraints  = updateSorting = true;
        }
        if ( updateFieldConstraints ) {
            updateFieldConstraints = false;
            if ( fieldConstraints != null ) {
                updateBoboBrowseResult = true;
                applyFieldConstraints();
            }
        }
        if ( updateNamespaceConstraint && !namespaceConstraint.isEmpty() ) {
            updateNamespaceConstraint = false;
            updateBoboBrowseResult = true;
            applyNamespaceConstraint();
        }
        if ( updateSorting && !sortFields.isEmpty() ) {
            updateSorting = false;
            fullTextQuery.setSort( sortObj );
        }
        fullTextQuery.setFirstResult( offset );
        fullTextQuery.setMaxResults( limit );
//        tmp = System.currentTimeMillis() - tmp;
//        log("ValidateQuery in "+ tmp + "ms");
        return true;
    }

    //Recursive function that combines all queries from QueryDef objects
    private Query createLuceneQuery( QueryDef qd ) throws ParseException {

        Query toReturn;

        switch (qd.queryType){
            case PARSED_LUCENE : toReturn = qd.parsedQuery; break;
            case PARSED_STRING : toReturn = getParsedQuery(qd); break;
            case RANGE         : toReturn = createRangeQuery(qd); break;
            case PHRASE        : toReturn = createMultiFieldPhraseQuery(qd); break;
            case TEXT          : toReturn = createMultiFieldQuery(qd); break;
            case MATCH_ALL     : toReturn = createMatchAllQuery(); break;
            default            : toReturn = null; break;
        }

        if( !qd.children.isEmpty() ) {
            BooleanQuery booleanQuery = new BooleanQuery();
            if(toReturn != null)
                booleanQuery.add( toReturn, qd.occur );

            for ( QueryDef child : qd.children )
                booleanQuery.add( createLuceneQuery( child ), child.occur );

            toReturn = booleanQuery;
        }

        return toReturn;
    }

    private Query createRangeQuery( QueryDef qd ) throws ParseException {
        QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity( entityClass ).get();
        FromRangeContext<Object> fromContext = builder.range().onField( qd.fields[0]).from( qd.min );
        RangeTerminationExcludable toContext = qd.includeMin? fromContext.to( qd.max ) : fromContext.excludeLimit().to( qd.max );
        return qd.includeMax ? toContext.createQuery() : toContext.excludeLimit().createQuery();
    }

    protected abstract BoboIndexReader getBoboReader( String field );

    protected static FacetHandler<?> getFacetHandlerForField( String field ) {
        return new MultiValueFacetHandler( field, field );
    }

    private List<WebDSLFacet> getBoboFacets( String field, boolean ignoreFacetSelection ) {
        validateQuery();
//        long time =  System.currentTimeMillis();
        if ( updateBoboBrowseResult) {
            updateBoboBrowseResult( field, ignoreFacetSelection );
        }
        // obtain facet result
        FacetAccessible facets = boboBrowseResult.getFacetMap().get( field );
        if (facets == null) {
            updateBoboBrowseResult( field, ignoreFacetSelection );
            facets = boboBrowseResult.getFacetMap().get( field );
        }

        List<BrowseFacet> facetVals = facets.getFacets();
        List<WebDSLFacet> toReturn = new ArrayList<WebDSLFacet>();
        WebDSLFacet facet;
        int index, cnt;
        for( BrowseFacet bf : facetVals )
        {
            facet = new WebDSLFacet( bf, field );
            index = filteredFacetsList.indexOf( facet );
            if ( index > -1 ) {
                cnt = facet.count;
                facet = filteredFacetsList.get( index );
                facet.count = cnt;
            }
            toReturn.add( facet );
        }
//        log("get bobo facets in " + ( System.currentTimeMillis() - time ) + "ms");
        return toReturn;
    }

    private void updateBoboBrowseResult( String field, boolean includeOldFacets ) {
        FacetSpec facetSpec;
        SortField srtfld;
        BrowseRequest br = new BrowseRequest();
        int max = 0;

        for ( Entry<String, Integer> rq : discreteFacetRequests.entrySet() ) {
            max = Math.max( max, rq.getValue() );
            // add the facet output specs
            facetSpec = new FacetSpec();
            facetSpec.setMaxCount( rq.getValue() );
            facetSpec.setOrderBy( FacetSortSpec.OrderHitsDesc );

            srtfld = new SortField( rq.getKey(),sortType( rq.getKey() ), true );

            //setFacetSpec ADDS a spec to its facet spec map
            br.setFacetSpec( rq.getKey(),facetSpec );
            br.addSortField( srtfld );
        }

        br.setCount( max );
        br.setOffset( 0 );

        Query boboQuery = getBoboQuery( includeOldFacets );
        br.setQuery( boboQuery );

        BoboIndexReader boboReader = getBoboReader( field );

        // perform browse
        Browsable browser;
        try {
            browser = new BoboBrowser( boboReader );
            boboBrowseResult = browser.browse( br );
        } catch ( IOException e ) {
            e.printStackTrace();
        } catch ( BrowseException e ) {
            e.printStackTrace();
        }

        updateBoboBrowseResult = false;
    }

    private Query getBoboQuery( boolean includeOldFacets ) {
        Query boboQuery = ( includeOldFacets ) ? luceneQueryNoFacetFilters : luceneQuery;
        boolean hasNamespaceConstraint = ( namespaceConstraint != null && !namespaceConstraint.isEmpty() );
        boolean hasFieldConstraint = ( fieldConstraints != null && !fieldConstraints.isEmpty() );
        if ( hasNamespaceConstraint || hasFieldConstraint ) {
            //Apply field constraints and namespace constraints through query, when enabled
            BooleanQuery bq = new BooleanQuery();
            bq.add( boboQuery, Occur.MUST );

            if ( hasFieldConstraint ) {
                for ( Entry<String, String> kv : fieldConstraints.entrySet() ) {
                    QueryParser qp = new QueryParser( LUCENEVERSION, kv.getKey(), analyzer );
                    try {
                        if ( allowLuceneSyntax )
                            bq.add( qp.parse( kv.getValue() ), Occur.MUST );
                        else
                            bq.add( qp.parse( QueryParser.escape( kv.getValue() )), Occur.MUST );
                    } catch ( ParseException e ) {
                        e.printStackTrace();
                    }
                }
            }

            if ( hasNamespaceConstraint ) {
                bq.add( new TermQuery( new Term( SearchHelper.NAMESPACEFIELD, namespaceConstraint ) ), Occur.MUST );
            }
            boboQuery = bq;
        }
        return boboQuery;
    }

}