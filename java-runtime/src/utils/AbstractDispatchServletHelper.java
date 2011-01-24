package utils;

import javax.servlet.http.HttpServletRequest;
import org.webdsl.lang.*;
import java.util.ArrayList;
import java.util.List;

public abstract class AbstractDispatchServletHelper{
  public abstract String getContextPath();
  public abstract String getRequestedPage();
  public boolean isPostRequest;
  public abstract HttpServletRequest getRequest();
  public abstract java.util.HashMap<String, utils.PageDispatch> getPages();
  public abstract int getHttpsPort();
  public abstract int getHttpPort();
  public abstract void setEndTimeAndStoreRequestLog(org.hibernate.Session hibSession);
  public static List<ReflectionEntity> reflectionentities = new ArrayList<ReflectionEntity>();
  public static List<ReflectionEntity> getReflectionEntities(){ return reflectionentities; }
  public static ReflectionEntity getReflectionEntityByName(String name){
      for(ReflectionEntity e: reflectionentities){
          if(e.getName().equals(name)){
              return e;
          }
      }
      System.out.println("reflection entity not found: "+name);
      return null; 
  }
}