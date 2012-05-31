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
  
  public static Date addYears(Date d, int amount) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      c.add(Calendar.YEAR,amount);
      return c.getTime();
  }
  public static Date addMonths(Date d, int amount) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      c.add(Calendar.MONTH,amount);
      return c.getTime();
  }
  public static Date addDays(Date d, int amount) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      c.add(Calendar.DATE,amount);
      return c.getTime();
  }
  public static Date addHours(Date d, int amount) {
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.HOUR,amount);
    return c.getTime();
  }
  public static Date addMinutes(Date d, int amount) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      c.add(Calendar.MINUTE,amount);
      return c.getTime();
  }
  public static Date addSeconds(Date d, int amount) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      c.add(Calendar.SECOND,amount);
      return c.getTime();
  }
  
  public static int getYear(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.YEAR);
  }
  public static int getMonth(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.MONTH);
  }
  public static int getDay(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.DAY_OF_MONTH);
  }
  public static int getDayOfYear(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.DAY_OF_YEAR);
  }
  public static int getHour(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.HOUR);
  }
  public static int getMinute(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.MINUTE);
  }
  public static int getSecond(Date d) {
      Calendar c = Calendar.getInstance();
      c.setTime(d);
      return c.get(Calendar.SECOND);
  }
  
}
