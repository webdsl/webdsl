package org.webdsl.search;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import org.apache.lucene.document.DateTools;
import org.hibernate.annotations.common.util.StringHelper;
import org.hibernate.search.SearchException;
import org.hibernate.search.annotations.Resolution;
import org.hibernate.search.bridge.ParameterizedBridge;
import org.hibernate.search.bridge.TwoWayStringBridge;
import org.hibernate.search.bridge.builtin.DateResolutionUtil;

/**
 * Modified DateBridge based on the one from Hibernate Search.
 * This bypasses the timezone conversion which is done in Lucene DateTools, which
 * converted date objects to GMT timezone.
 */
//TODO split into StringBridge and TwoWayStringBridge?
public class WebDSLDateBridge implements TwoWayStringBridge, ParameterizedBridge{

	SimpleDateFormat YEAR = new SimpleDateFormat("yyyy");
	SimpleDateFormat MONTH = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat DAY = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat HOUR = new SimpleDateFormat("yyyyMMddHH");
    SimpleDateFormat MINUTE = new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat SECOND = new SimpleDateFormat("yyyyMMddHHmmss");
    SimpleDateFormat MILLISECOND = new SimpleDateFormat("yyyyMMddHHmmssSSS");

	private DateTools.Resolution resolution;

	public WebDSLDateBridge() {
	}

	public WebDSLDateBridge(Resolution resolution) {
		this.resolution = DateResolutionUtil.getLuceneResolution(resolution);
	}

	public Object stringToObject(String stringValue) {
		if ( StringHelper.isEmpty( stringValue ) ) return null;
		try {
			return DateTools.stringToDate( stringValue );
		}
		catch (ParseException e) {
			throw new SearchException( "Unable to parse into date: " + stringValue, e );
		}
	}

	public String objectToString(Object object) {
		return object != null ?
				nonNullDateToString( (Date) object ):
				null;
	}
	
	public String nonNullDateToString(Date date){
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		

	    switch (resolution) {
	      case YEAR: return YEAR.format(date);
	      case MONTH:return MONTH.format(date);
	      case DAY:  return DAY.format(date);
	      case HOUR: return HOUR.format(date);
	      case MINUTE: return MINUTE.format(date);
	      case SECOND: return SECOND.format(date);
	      case MILLISECOND: return MILLISECOND.format(date);
	      default: throw new SearchException( "Unable to convert date: '" + date.toString() + "' to String" );
	    }
	}

	public void setParameterValues(Map parameters) {
		Object resolution = parameters.get( "resolution" );
		Resolution hibResolution;
		if ( resolution instanceof String ) {
			hibResolution = Resolution.valueOf( ( (String) resolution ).toUpperCase( Locale.ENGLISH ) );
		}
		else {
			hibResolution = (Resolution) resolution;
		}
		this.resolution = DateResolutionUtil.getLuceneResolution( hibResolution );
	}
	
}