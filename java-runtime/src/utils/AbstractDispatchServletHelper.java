package utils;

import javax.servlet.http.HttpServletRequest;
import org.webdsl.lang.*;
import java.util.ArrayList;
import java.util.List;
import org.webdsl.*;
import java.util.UUID;

public abstract class AbstractDispatchServletHelper{
  public abstract String getContextPath();
  public abstract String getRequestedPage();
  public boolean isPostRequest;
  public abstract HttpServletRequest getRequest();
  public abstract WebDSLEntity getSessionManager();
  public abstract void loadSessionManager(org.hibernate.Session h);
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

  public static AbstractDispatchServletHelper get(){
      return ThreadLocalServlet.get();
  }
  
  //messages

  protected List<String> incomingSuccessMessages = new java.util.LinkedList<String>();

  public List<String> getIncomingSuccessMessages() {
    return incomingSuccessMessages;
  }
  
  public void clearIncomingSuccessMessages() {
    incomingSuccessMessages.clear();
  }

  protected List<String> outgoingSuccessMessages = new java.util.LinkedList<String>();

  public List<String> getOutgoingSuccessMessages() {
    return outgoingSuccessMessages;
  }

  public abstract void storeOutgoingMessagesInHttpSession();
  public abstract void retrieveIncomingMessagesFromHttpSession();
}