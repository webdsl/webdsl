package org.hibernate.search.query.dsl.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.search.FullTextSession;
import org.hibernate.search.engine.DocumentBuilderIndexedEntity;
import org.hibernate.search.query.dsl.impl.FacetRange;
import org.hibernate.search.query.dsl.impl.FacetingRequestImpl;
import org.hibernate.search.query.dsl.impl.RangeFacetRequest;
import org.hibernate.search.query.facet.FacetSortOrder;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.util.ContextHelper;

import utils.DateType;

@SuppressWarnings("deprecation")
public class WebDSLFacetTool {

	public static <T> FacetingRequest toFacetingRequest(String field, String rangeAsString, Class<?> entityClass, Class<T> type, FullTextSession fts){
		List<FacetRange<T>> facetRangeList = new ArrayList<FacetRange<T>>();

		DocumentBuilderIndexedEntity<?> documentBuilder = ContextHelper.getSearchFactory(fts).getDocumentBuilderIndexedEntity(entityClass);
		
		String[] splitted = rangeAsString.substring(1, rangeAsString.length()-1).split("\\)\\(");
		FacetRange<T> range;
		T start, end;
		for(int i=0; i<splitted.length; i++){
			if(splitted[i].startsWith(",")){
				start = null;
				end = (T) stringToTypedObject(splitted[i].substring(1),type);				
				range = new FacetRange<T>( end.getClass(), start, end, true, true, field, documentBuilder);
			}
			else if(splitted[i].endsWith(",")){
				start = (T) stringToTypedObject(splitted[i].substring(0, splitted[i].length()-1),type);
				end = null;				
				range = new FacetRange<T>(start.getClass(), start, end, true, true, field, documentBuilder);
			}
			else{
				String[] fromNto = splitted[i].split(",");
				start = (T) stringToTypedObject(fromNto[0],type);
				end = (T) stringToTypedObject(fromNto[1],type);
				range = new FacetRange<T>(start.getClass(), start, end, true, true, field, documentBuilder);
			}
			facetRangeList.add(range);
		}
		FacetingRequestImpl rfr = new RangeFacetRequest<T>( facetName(field), field, facetRangeList, documentBuilder );
		rfr.setSort( FacetSortOrder.RANGE_DEFINITION_ODER );
		rfr.setIncludeZeroCounts( false );
		rfr.setMaxNumberOfFacets( splitted.length );
		
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
