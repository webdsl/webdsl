package utils;

import java.util.*;

public class DateType {
    
  public static String format(Date d, String s){
    return (new java.text.SimpleDateFormat(s).format(d,new StringBuffer(),new java.text.FieldPosition(0))).toString();
  }
}
