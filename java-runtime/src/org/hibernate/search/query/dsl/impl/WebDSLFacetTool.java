package org.hibernate.search.query.dsl.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.hibernate.search.FullTextSession;
import org.hibernate.search.engine.spi.DocumentBuilderIndexedEntity;
import org.hibernate.search.engine.spi.SearchFactoryImplementor;
import org.hibernate.search.query.facet.FacetSortOrder;
import org.hibernate.search.query.facet.FacetingRequest;

import utils.DateType;

public class WebDSLFacetTool {

    private static final Pattern p = Pattern.compile("(\\[|\\{)([^\\]\\}])*\\sTO\\s([^\\]\\}])*(\\]|\\})", Pattern.CASE_INSENSITIVE);

    public static <T> FacetingRequest toFacetingRequest(String field, String rangeAsString, Class<?> entityClass, Class<T> type, FullTextSession fts){

        List<FacetRange<T>> facetRangeList = new ArrayList<FacetRange<T>>();
        SearchFactoryImplementor factory = (SearchFactoryImplementor) fts.getSearchFactory();
		DocumentBuilderIndexedEntity<?> documentBuilder = factory.getIndexBindingForEntity( entityClass ).getDocumentBuilder();
        Matcher matcher = p.matcher( rangeAsString );
        FacetRange<T> range;
        T min, max;

        boolean includeMin, includeMax;
        while(matcher.find()){
            includeMin = matcher.group(1).equals("[");
            min = ( matcher.group( 2 ).isEmpty() ) ? null : (T) stringToTypedObject( matcher.group( 2 ).trim(), type );
            max = ( matcher.group( 3 ).isEmpty() ) ? null : (T) stringToTypedObject( matcher.group( 3 ).trim(), type );
            includeMax = matcher.group(4).equals("]");

            range = new FacetRange<T>( max.getClass(), min, max, includeMin, includeMax, field, documentBuilder );
            facetRangeList.add(range);
        }
        FacetingRequestImpl rfr = new RangeFacetRequest<T>( facetName(field), field, facetRangeList, documentBuilder );
        rfr.setSort( FacetSortOrder.RANGE_DEFINITION_ODER );
        rfr.setIncludeZeroCounts( false );
        rfr.setMaxNumberOfFacets( facetRangeList.size() );

        return rfr;
    }


    @SuppressWarnings("unchecked")
    private static <T> T stringToTypedObject(String toConvert, Class<T> type) {
        if(type.isAssignableFrom(String.class))
            return (T) toConvert;
        if(type.isAssignableFrom(Integer.class))
            return (T) new Integer(toConvert);
        if(type.isAssignableFrom(Float.class))
            return (T) new Float(toConvert);
        if(type.isAssignableFrom(Date.class)){
            try {
                if(toConvert.matches("[^:]+"))
                    return (T) new SimpleDateFormat(DateType.getDefaultDateFormat()).parse(toConvert);
                else if(toConvert.matches("[^/]+"))
                    return (T) new SimpleDateFormat(DateType.getDefaultTimeFormat()).parse(toConvert);
                else
                    return (T) new SimpleDateFormat(DateType.getDefaultDateTimeFormat()).parse(toConvert);
            } catch (ParseException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return (T) new Date();
            }

        }
        else
            return (T) toConvert;
    }

    public static String facetName(String field){
        return "facet_" + field;
    }
}
