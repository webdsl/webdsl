package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
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
import org.apache.lucene.search.PhraseQuery;
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
import org.hibernate.search.query.dsl.impl.WebDSLFacetTool;
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.store.DirectoryProvider;
import org.webdsl.WebDSLEntity;

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

public abstract class AbstractEntitySearcher<EntityClass extends WebDSLEntity, F> {

	protected static final Version LUCENEVERSION 		= Version.LUCENE_31;
	protected static final int LIMIT 					= 50;
	protected static final int OFFSET 					= 0;
	protected static final Operator OP  				= Operator.OR;
	protected static final boolean ALLOWLUCENESYNTAX 	= true;
	
	protected int limit = LIMIT;
	protected int offset = OFFSET;
	protected Operator defaultOperator = OP;
	
	protected boolean updateFullTextQuery, updateSorting, updateFacets, updateNamespaceConstraint, updateFieldConstraints, updateLuceneQuery = true, updateParamMap = true, updateHighlightQuery = true;
	protected boolean allowLuceneSyntax = true, searchFieldsChanged = false, updateBoboBrowseResult = true;

	protected HashMap<String, String> fieldConstraints;
	protected HashMap<String, Float> boosts;
	protected HashMap<String, Facet> facetMap;
	protected HashMap<String, String> rangeFacetRequests;
	protected HashMap<String, Integer> discreteFacetRequests;
	protected Map<String, String> paramMap;
	private BrowseResult boboBrowseResult;

	protected LinkedList<WebDSLFacet> filteredFacetsList = new LinkedList<WebDSLFacet>();
	
	protected Query luceneQueryNoFacetFilters, highlightQuery, luceneQuery = null;
	protected FullTextQuery fullTextQuery = null;
	protected FullTextSession fullTextSession;
	
	protected String[] untokenizedFields;
	protected String[] searchFields;
	protected String[] mltSearchFields;
	protected String indexName;
	
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
	public F filterByField( String fieldname, String terms ) {
		if ( fieldConstraints == null )
			fieldConstraints = new HashMap<String, String>();
		
		fieldConstraints.put( fieldname, terms );
		updateFieldConstraints = updateParamMap = true;
		return ( F ) this;
	}
	
	public String getFieldFilterValue( String fieldname ) {
		if ( fieldConstraints == null )
			fieldConstraints = new HashMap<String, String>();
		return fieldConstraints.get( fieldname );
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
	@SuppressWarnings("unchecked")
	public F closeGroup() {
		parentQD = ( parentQD == rootQD ) ? parentQD : parentQD.parent;
		return ( F ) this;
	}
	@SuppressWarnings("unchecked")
	public F openGroup() {
		parentQD = currentQD;	
		return ( F ) this;
	}
	
	private final void addSubQuery( Occur oc ) {
		currentQD = new QueryDef( oc, parentQD, searchFields );		
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
			if ( discreteFacetRequests.containsKey( facet.getFieldName() )) {
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
			} else if ( rangeFacetRequests.containsKey( facet.getFieldName() )) {
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
		if ( boosts == null )
			boosts = new HashMap<String, Float>();
		if ( boosts.containsKey( field ))
			boosts.remove( field );
		
		boosts.put( field, boost );
		updateLuceneQuery = updateParamMap = true;
		return ( F ) this;
	}
	public void closeReader( IndexReader reader ) {
		if ( reader != null )
		getFullTextSession().getSearchFactory().getReaderProvider().closeReader( reader );
	}
	
	private Query createMultiFieldQuery( QueryDef qd ) throws ParseException {
		if ( qd.hasParsedQuery )
			return luceneQueryFromString( qd.parsedQuery );
		
		if (!qd.query.isEmpty() ) {			
			SpecialMultiFieldQueryParser parser;
			if ( boosts == null || boosts.isEmpty() ) 
				parser = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer );
			 else 
				parser = new SpecialMultiFieldQueryParser( LUCENEVERSION, qd.fields, analyzer, boosts );
						
			parser.setDefaultOperator( defaultOperator );
			
			try {
				if ( qd.isPhraseQuery ) 
					return parser.parse( "\"" + SpecialMultiFieldQueryParser.escape( qd.query ) + "\"~" + qd.slop);
				else if ( allowLuceneSyntax )
					return parser.parse( qd.query );
				else					
					return parser.parse( SpecialMultiFieldQueryParser.escape( qd.query ));
			} catch ( org.apache.lucene.queryParser.ParseException pe ) {
				pe.printStackTrace();
				return null;
			}
			//log("Terms: " + query() );
			//log("Lucene query: " + luceneQuery.toString() );
			
		}
		// Match all documents if no search terms are given
		else {
			return getFullTextSession().getSearchFactory()
					.buildQueryBuilder().forEntity( entityClass ).get().all()
					.createQuery();
		}
	}
	
	private String decodeValue( String str ) {
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
		
	public final Map<String,String> toParamMap() {
		if (!updateParamMap ) {
			return paramMap;
		}
		
		paramMap = new HashMap<String, String>();
		StringBuilder sb;
		
		if ( searchFieldsChanged ) {
		sb = new StringBuilder();
		for( int cnt = 0 ; cnt < searchFields.length-1; cnt++ )
			sb.append( searchFields[cnt] + "," );
		sb.append( searchFields[searchFields.length-1] );
		paramMap.put( "sf", sb.toString() );
		}
		//search terms
		if ( rootQD.children.isEmpty() ) {
			if ( rootQD.isRangeQuery )
				paramMap.put( "lq", getLuceneQueryAsString() );
			else
				paramMap.put( "q", rootQD.query );
		} else {	
			QueryDef fstChild = rootQD.children.get( 0 );
			if ( rootQD.children.size() == 1 && fstChild.occur.equals( Occur.SHOULD ) && !fstChild.isRangeQuery ) {
				if( fstChild.isPhraseQuery ) {
				    paramMap.put( "pq", fstChild.query );
				    paramMap.put( "sl", String.valueOf( fstChild.slop ) );
				} else {
				    paramMap.put( "q", fstChild.query );
				}
			}
			else
				paramMap.put( "lq", getLuceneQueryAsString() );
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
		
		//boost fields, values		
		if ( boosts!=null && !boosts.isEmpty() ) {
			sb = new StringBuilder();
			for ( String field : boosts.keySet() ) sb.append( field + ",");
			paramMap.put("bf", sb.toString() );
			sb = new StringBuilder();
			for ( Float value : boosts.values() ) sb.append( value + ",");
			paramMap.put("bv", sb.toString() );
		}
		
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
	
	@SuppressWarnings("unchecked")
	public F fromParamMap( Map<String,String> paramMap ) {
		try {
			String key, value;
			for ( Map.Entry<String,String> e : paramMap.entrySet() ) {
				key = e.getKey();
				value = e.getValue();
				if ("sf".equals( key )) {
					// search fields
					fields( new ArrayList<String>( Arrays.asList( value.split(",") )) );
				} else if ("q".equals( key )) {
					//ordinary query
					query( value );
				} else if ("lq".equals( key )) {
					//search query, lucene string representation
					currentQD.parsedQuery( value );
				} else if ("pq".equals( key )) {
					//phrase query
					phraseQuery( value, Integer.parseInt( paramMap.get( "sl" ) ) );
				} else if ("op".equals( key ) && value.equals("AND") ) {
					//change default operator to AND
					defaultAnd();
				} else if ("cf".equals( key )) {
					//constraint fields, values
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("cv").split(",");
					for( int i=0; i < a1.length; i++)
						filterByField( a1[i], a2[i]);
				} else if ("rff".equals( key )) {
					//range facet fields, params
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("rfp").split(",");
					String field;
					String param;
					rangeFacetRequests = new HashMap<String, String>();
					for( int i=0; i < a1.length; i++) {
						field = a1[i];
						param = decodeValue( a2[i]);
						enableFaceting( field, param );
					}
					
				} else if ("dff".equals( key )) {
					//discrete facet fields, params
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("dfp").split(",");
					String field;
					int param;
					discreteFacetRequests = new HashMap<String, Integer>();
					for( int i=0; i < a1.length; i++) {
						field = a1[i];
						param = Integer.parseInt( a2[i]);
						enableFaceting( field, param );
					}
					
				} else if ("lim".equals( key )) {
					//limit
					maxResults( Integer.parseInt( value ));
				} else if ("offset".equals( key )) {
					//offset
					firstResult( Integer.parseInt( value ));
				} else if ("bf".equals( key )) {
					//boost fields, values
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("bv").split(",");
					for( int i=0; i < a1.length; i++)
						boost( a1[i], Float.parseFloat( a2[i]) );
				} else if ("ffld".equals( key )) {
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("fvl").split(",");
					String[] a3 = paramMap.get("focc").split(",");
					String[] a4 = paramMap.get("fcnt").split(",");
					for( int i=0; i < a1.length; i++) {
						filterByFacet( new WebDSLFacet( a1[i], decodeValue( a2[i] ), Occur.valueOf( a3[i] ), Integer.parseInt( a4[i] ) ) );						
					}
				} else if ("sortby".equals( key )) {
					//sort fields, directions
					String[] a1 = value.split(",");
					String[] a2 = paramMap.get("dirs").split(",");
					for( int i=0; i < a1.length; i++)
						sort( a1[i], Boolean.getBoolean( a2[i]) );
				} else if ("mlt".equals( key )) {
					//more like this
					String[] a1 = value.split(",");
					moreLikeThis( a1[0], Integer.parseInt( a1[1]), Integer.parseInt( a1[2]), Integer.parseInt( a1[3]), Integer.parseInt( a1[4]), Integer.parseInt( a1[5]), Integer.parseInt( a1[6]) );
				} else if ("allowlcn".equals( key )) {
					// allow Lucene syntax?
					Boolean.parseBoolean( value );					
				} else if ("ns".equals( key )) {
					//namespace
					setNamespace( value );
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
			log("Error during entity searcher decoding!");
		}
		
		this.paramMap = paramMap;
		updateParamMap = false;
		return ( F ) this;		
		
	}
	
	
	private String encodeValue( String str ) {
		return str.replaceAll("\\\\", "\\\\\\\\ ").replaceAll(",", "\\\\c");
	}
	
	@SuppressWarnings("unchecked")
	public F enableFaceting( String field, int topN ) {		
		if ( discreteFacetRequests == null )
			discreteFacetRequests = new HashMap<String, Integer>();
		
		discreteFacetRequests.put( field, topN );
		updateParamMap = true;
		
		return ( F ) this;
	}
	
	// example ranges: "( TO 100 )( 100 TO 200 )( 200 TO )"   "(-200 TO -100 )(-100 TO 0 )( 0 TO )"
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
	
	public List<WebDSLFacet> getFacets( String field ) {
		return getFacets( field, false );
	}
	
	public List<WebDSLFacet> getFacets( String field, boolean includeOldFacets ) {

		if ( discreteFacetRequests.containsKey( field )) {
			return getBoboFacets( field, includeOldFacets );
		} else if ( rangeFacetRequests.containsKey( field )) {
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
	
	public List<WebDSLFacet> getFilteredFacets() {
		return filteredFacetsList;
	}
	
	@SuppressWarnings("unchecked")
	public F removeFilteredFacet( WebDSLFacet f ) {
		filteredFacetsList.remove( f );
		
		updateFacets = updateParamMap = true;
		return ( F ) this;
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
	
	public abstract Class<?> fieldType( String field );
	
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
	
	@SuppressWarnings("unchecked")
	public F firstResult( int offset ) {
		this.offset = offset;
		updateParamMap = true;
		return ( F ) this;
	}

	protected abstract FullTextSession getFullTextSession ();
	
	public IndexReader getReader() {
		SearchFactory searchFactory = getFullTextSession().getSearchFactory();
		DirectoryProvider<?>[] providers = searchFactory
				.getDirectoryProviders( entityClass );

		return searchFactory.getReaderProvider().openReader( providers );
	}
	
	public static String escapeQuery( String query ) {
		return QueryParser.escape( query );
	}
	
	public String highlight( String field, String toHighLight ) {
		validateQuery();
		return ResultHighlighter.highlight( analyzer, getHighlightQuery(), field, toHighLight );
	}

	public String highlight( String field, String toHighLight, String preTag, String postTag ) {
		validateQuery();
		return ResultHighlighter.highlight( analyzer, getHighlightQuery(), field, toHighLight, preTag, postTag );
	}
	
	public String highlight ( String field, String toHighLight, String preTag, String postTag, int fragments, int fragmentLength, String separator ) {
		validateQuery();
		return ResultHighlighter.highlight( analyzer, getHighlightQuery(), field, toHighLight, preTag, postTag, fragments, fragmentLength, separator );
	}
	@SuppressWarnings("unchecked")
	public List<EntityClass> list() {
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
	public F maxResults( int limit ) {
		this.limit = limit;
		updateParamMap = true;
		return ( F ) this;
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
			luceneQuery = mlt.like( new StringReader( likeText ));
		} catch ( IOException e ) {
			e.printStackTrace();
		} finally {
			closeReader( ir );
		}
		updateLuceneQuery = false;
		updateFullTextQuery = updateParamMap = true;

		return ( F ) this;
	}
	
	@SuppressWarnings("unchecked")
	public F filterByFacet( WebDSLFacet facet ) {		
		//if already narrowed on this facet, don't add it again
		//A facet already appears in the list if field and value are equal
		if ( filteredFacetsList.contains( facet ))
			return ( F ) this;
		
		facet.isSelected = true;
		filteredFacetsList.add( facet );
	
		updateFacets = updateParamMap = true;
		return ( F ) this;
	}
	
	public F range( Date from, Date to ) {
		return ( F ) setRangeQuery( from,to );
	}
	
	public F range( Float from, Float to ) {
		return ( F ) setRangeQuery( from,to );
	}

	public F range( int from, int to ) {
		return ( F ) setRangeQuery( from,to );
	}

	public F range( String from, String to ) {
		return ( F ) setRangeQuery( from,to );
	}

	@SuppressWarnings("unchecked")
	public F resetSorting() {
		sortObj = null;
		this.sortFields = "";
		this.sortDirections = "";
		updateSorting = updateParamMap = true;
		return ( F )this;
	}

	public int resultSize() {
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
	public String searchTimeAsString() {
		return searchTime + " ms";
	}

	public int searchTimeMillis() {
		return ( int ) this.searchTime;
	}

	public float searchTimeSeconds() {
		return ( float ) ( this.searchTime / 1000 );
	}
	
	@SuppressWarnings("unchecked")
	private F setRangeQuery( Object from, Object to ) {
		currentQD.range( from, to );
	
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
		
	public String query() {
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
			} catch ( ParseException e ) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return luceneQuery.toString("Error occured during query parsing");
			}
			updateLuceneQuery = false;
			updateFullTextQuery = true;
		}
		return luceneQuery.toString();
	}

	private Query luceneQueryFromString( String str ) throws ParseException {
		return new QueryParser( LUCENEVERSION, "", this.analyzer ).parse( str );
	}
	
	private boolean validateQuery() {
//		long tmp = System.currentTimeMillis();
		if ( updateLuceneQuery ) {
			try {
				luceneQuery = createLuceneQuery( rootQD );
				luceneQueryNoFacetFilters = luceneQuery;
			} catch ( ParseException e ) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
//			log("LUCENE QUERY: " + luceneQuery.toString() );
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
//		tmp = System.currentTimeMillis() - tmp;
//		log("ValidateQuery in "+ tmp + "ms");
		return true;
	}
	
	//Recursive function that combines all queries from QueryDef objects	
	private Query createLuceneQuery( QueryDef qd ) throws ParseException {
		if ( qd.children.size() < 1 )
			return ( qd.isRangeQuery ) ? createRangeQuery( qd ) : createMultiFieldQuery( qd );
		
		BooleanQuery booleanQuery = new BooleanQuery();
		
		for ( QueryDef child : qd.children )
			booleanQuery.add( createLuceneQuery( child ), child.occur );
		
		return booleanQuery;
	}

	private Query createRangeQuery( QueryDef qd ) throws ParseException {
		if ( qd.hasParsedQuery )
			return luceneQueryFromString( qd.parsedQuery );
		QueryBuilder builder = getFullTextSession().getSearchFactory().buildQueryBuilder().forEntity( entityClass ).get();
		return builder.range().onField( qd.fields[0]).from( qd.from ).to( qd.to ).createQuery();
	}
	
	protected abstract BoboIndexReader getBoboReader( String field, Collection<String> allFields );
	
	protected static FacetHandler<?> getFacetHandlerForField( String field ) {
		return new MultiValueFacetHandler( field, field );
	}
	
	private Query getHighlightQuery() {
		if ( updateHighlightQuery ) {
			IndexReader ir = null;
			try {
				ir = getReader();
				highlightQuery = luceneQueryNoFacetFilters.rewrite( ir );
				updateHighlightQuery = false;
//				log("HIGHLIGHT QUERY: " + highlightQuery.toString());
			} catch ( IOException e ) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				closeReader(ir);
			}
		}
		return highlightQuery;
	}

	private List<WebDSLFacet> getBoboFacets( String field, boolean includeOldFacets ) {
		validateQuery();
//		long time =  System.currentTimeMillis();
		if ( updateBoboBrowseResult ) {
			updateBoboBrowseResult( field, includeOldFacets );
	    }
		// obtain facet result
		FacetAccessible facets = boboBrowseResult.getFacetMap().get( field );
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
//		log("get bobo facets in " + ( System.currentTimeMillis() - time ) + "ms");
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
		
		BoboIndexReader boboReader = getBoboReader( field, discreteFacetRequests.keySet() );
		
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