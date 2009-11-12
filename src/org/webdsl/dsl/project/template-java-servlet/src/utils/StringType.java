package utils;

import java.util.*;

public class StringType {
    
    public static Integer parseInt(String s){
      try{
    	  return Integer.parseInt(s);
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
        StringBuffer ret = new StringBuffer();
        for(String str : s){
        	if(ret.length() == 0){
        		ret.append(str);
        	}
        	else{
        		ret.append(sep);
        		ret.append(str);
        	}
        }
        return ret.toString();
    }
    
    public static String concat(List<String> s){
    	StringBuffer ret = new StringBuffer();
    	for(String str : s){
    		ret.append(str);
    	}
    	return ret.toString();
    }
    
    public static List<String> splitWithSeparator(String s, String sep){
        List<String> list = new LinkedList<String>();
        String[] tokens = org.apache.commons.lang.StringUtils.splitByWholeSeparator(s,sep);
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
    
    public static String removeTrailingDefaultValues(String s, String... strings){
        String[] parts = s.split("/");
        int i = 0;
        for(i = parts.length - 1; i >= 0; i--){
          if( !(parts[i].equals("") && utils.TypesInfo.getStringCompatibleTypes().contains(strings[i]))
           && !(parts[i].equals("0") && strings[i].equals("Int"))
           && !(parts[i].equals("0.0") && strings[i].equals("Float"))
          ){
        	  break;
          }
        }
        StringBuffer sb = new StringBuffer();
        for(int j = 0; j <= i; j++){
        	sb.append("/");
        	sb.append(parts[j]);
        }
        return sb.toString();
    }
}
