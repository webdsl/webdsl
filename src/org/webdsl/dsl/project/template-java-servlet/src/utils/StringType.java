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
    
}
