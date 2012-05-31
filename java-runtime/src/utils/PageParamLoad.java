package utils;

public class PageParamLoad {

    public static org.webdsl.WebDSLEntity loadEntity(org.hibernate.Session hibSession, String c, java.util.UUID s){
    try{
      return (org.webdsl.WebDSLEntity) hibSession.load(org.hibernate.internal.util.ReflectHelper.classForName(c),s);
    }
    catch(Exception e){
      e.printStackTrace();
      return null;
    }
  }

  public static org.webdsl.WebDSLEntity loadEntityFromParam(org.hibernate.Session hibSession, String domainpackage, String typeid){
    String[] x_ar = typeid.split(":");
    String x_type = x_ar[0];
    String x_uuid = x_ar[1];
    try {
      Class<?> cl = org.hibernate.internal.util.ReflectHelper.classForName(domainpackage + "." + x_type);
      return (org.webdsl.WebDSLEntity) hibSession.load(cl, java.util.UUID.fromString(x_uuid));
    }
    catch (ClassNotFoundException cnfe) {
      throw new RuntimeException(cnfe);
    }
  }
}
