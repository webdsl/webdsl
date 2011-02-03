package utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DateType {
    
  public static String format(Date d, String s){
    return (new java.text.SimpleDateFormat(s).format(d,new StringBuffer(),new java.text.FieldPosition(0))).toString();
  }
  
  private static final String defaultDateFormat = "dd/MM/yyyy";
  public static String getDefaultDateFormat(){
      return defaultDateFormat;
  }
  private static final String defaultTimeFormat =  "H:mm";
  public static String getDefaultTimeFormat(){
      return defaultTimeFormat;
  }
  private static final String defaultDateTimeFormat = "dd/MM/yyyy H:mm";
  public static String getDefaultDateTimeFormat(){
      return defaultDateTimeFormat;
  }
  
  public static Date parseDate(String date, String format) {
      try {
          return new SimpleDateFormat(format).parse(date);
      } catch (ParseException e) {
          return null;
      }
  }
  
  
}
