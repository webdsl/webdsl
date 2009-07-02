package utils;

public class EntityType {
    
    public static Object loadEntity(org.hibernate.Session hibSession, Class<?> c, java.util.UUID s){
      try{
    	  return hibSession.load(c,s);
      }
      catch(Exception e){
    	  return null;
      }
    }
    
}
