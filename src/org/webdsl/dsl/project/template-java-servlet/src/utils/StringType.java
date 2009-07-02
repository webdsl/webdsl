package utils;

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
    
}
