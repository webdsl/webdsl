package utils;

public class PageParamLoad {
  
  //`loadEntity` uses Hibernate's session.load method, which just returns a reference (possibly proxy) of an object that might not actually exist.
  public static org.webdsl.WebDSLEntity loadEntity(String c, java.util.UUID s){
    try{
      return (org.webdsl.WebDSLEntity) utils.HibernateUtil.getCurrentSession().load(org.hibernate.util.ReflectHelper.classForName(c),s);
    }
    catch(Exception e){
      org.webdsl.logging.Logger.error("EXCEPTION",e);
      return null;
    }
  }
  
  //Unlike `loadEntity`, this method uses Hibernate's session.get method, and will only return an entity when it actually exists (null otherwise).
  public static org.webdsl.WebDSLEntity getEntity(String c, java.util.UUID s){
    try{
      return (org.webdsl.WebDSLEntity) utils.HibernateUtil.getCurrentSession().get(org.hibernate.util.ReflectHelper.classForName(c),s);
    }
    catch(Exception e){
      org.webdsl.logging.Logger.error("EXCEPTION",e);
      return null;
    }
  }
    
  public static org.webdsl.WebDSLEntity loadEntityFromParam(String domainpackage, String typeid){
    String[] x_ar = typeid.split(":");
    String x_type = x_ar[0];
    String x_uuid = x_ar[1];
    try { 
      Class<?> cl = org.hibernate.util.ReflectHelper.classForName(domainpackage + "." + x_type);
      return (org.webdsl.WebDSLEntity) utils.HibernateUtil.getCurrentSession().load(cl, java.util.UUID.fromString(x_uuid));
    } 
    catch (ClassNotFoundException cnfe) { 
      throw new RuntimeException(cnfe); 
    }       
  }
}
