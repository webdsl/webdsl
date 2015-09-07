package utils;

import java.util.LinkedList;
import java.util.List;

public class StringType {

    public static Integer parseInt(String s){
      try{
          return Integer.parseInt(s);
      }
      catch(Exception e){
          return null;
      }
    }
    public static Long parseLong(String s){
        try{
            return Long.parseLong(s);
        }
        catch(Exception e){
            return null;
        }
    }
    public static Float parseFloat(String s){
        try{
            return Float.parseFloat(s);
        }
        catch(Exception e){
            return null;
        }
    }
    public static java.util.UUID parseUUID(String s){
        try{
            return java.util.UUID.fromString(s);
        }
        catch(Exception e){
            return null;
        }
    }

    public static String concatWithSeparator(List<String> s, String sep){
        return org.apache.commons.lang3.StringUtils.join(s, sep);
    }

    public static String concat(List<String> s){
        StringBuilder ret = new StringBuilder( 256 );
        for(String str : s){
            ret.append(str);
        }
        return ret.toString();
    }

    public static List<String> splitWithSeparator(String s, String sep){
        List<String> list = new LinkedList<String>();
        String[] tokens = org.apache.commons.lang3.StringUtils.splitByWholeSeparator(s,sep);
        for(String c : tokens){
            list.add(c);
        }
        return list;
    }

    public static List<String> split(String s){
        List<String> list = new LinkedList<String>();
        for(char c : s.toCharArray()){
            list.add(new Character(c).toString());
        }
        return list;
    }
    
    public static Float similarity(String s1, String s2){
    	return new Float(org.apache.commons.lang3.StringUtils.getJaroWinklerDistance(s1, s2));
    }

}
