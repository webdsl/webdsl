package utils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.WebDSLEntity;
import org.webdsl.lang.ReflectionEntity;

public abstract class AbstractDispatchServletHelper{
  public boolean isPostRequest;
  public abstract WebDSLEntity getSessionManager();
  public abstract void setSessionHasChanges();
  public abstract boolean sessionHasChanges();
  public abstract void reloadSessionManager(org.hibernate.Session h);
  public abstract void reloadSessionManagerFromExistingSessionId(org.hibernate.Session h, UUID sessionId);
  public abstract void loadSessionManager(org.hibernate.Session h);
  public abstract void loadSessionManager(org.hibernate.Session h, String[] joins);
  public abstract void setCookie(org.hibernate.Session h);
  public abstract void setEndTimeAndStoreRequestLog(org.hibernate.Session hibSession);
  public static List<ReflectionEntity> reflectionentities = new ArrayList<ReflectionEntity>();
  public static List<ReflectionEntity> getReflectionEntities(){ return reflectionentities; }
  public static ReflectionEntity getReflectionEntityByName(String name){
      for(ReflectionEntity e: reflectionentities){
          if(e.getName().equals(name)){
              return e;
          }
      }
      org.webdsl.logging.Logger.error("reflection entity not found: "+name);
      return null; 
  }

  public static AbstractDispatchServletHelper get(){
      return ThreadLocalServlet.get();
  }
  
  public static HashMap<String, utils.PageDispatch> pages = new HashMap<String, utils.PageDispatch>();
  public HashMap<String, utils.PageDispatch> getPages(){
    return pages;
  }

  Class pc;
  java.util.Map<String, List<utils.File>> fileUploads;
  java.util.Map<String, String> parammap;
  java.util.Map<String, List<String>> parammapvalues;
  HttpServletRequest request;
  public HttpServletRequest getRequest(){
    return request;
  }
  private String requestURLCached = null;
  private String requestURICached = null; 
  public String getRequestURL(){
    if(requestURLCached == null && getRequest() != null) {
      String url = getRequest().getRequestURL().toString();
      requestURLCached = replaceProtoInURI(url);
    }
    return requestURLCached;
  }
  public String getRequestURI(){
    if(requestURICached == null && getRequest() != null) {
      String uri = getRequest().getRequestURI();
      requestURICached = replaceProtoInURI(uri);
    }
    return requestURICached;
  }
  private String replaceProtoInURI( String u ) {
    String proto = getRequest().getHeader("x-forwarded-proto");
    return proto == null ? u : u.replaceFirst("\\w+://", proto + "://");
  }
  
  public String getRemoteAddress() {
    String address = getRequest().getRemoteAddr();
    if( "127.0.0.1".equals(address) || "0:0:0:0:0:0:0:1".equals(address) || "::1".equals(address) ){  // e.g. Nginx proxying to http port of Tomcat
      String forwardedFor = getRequest().getHeader("x-forwarded-for");
      if(forwardedFor != null) {
        address = forwardedFor;
      }
    }
    return address;
  }
  HttpServletResponse response;
  public HttpServletResponse getResponse(){
    return response;
  }
  
  public void forwardRequest(String to){
  	RequestDispatcher dispatcher = request.getRequestDispatcher(to);
  	String ExceptionString = "EXCEPTION";
  	try {
		dispatcher.forward(request, response);
	} catch (ServletException error) {
		org.webdsl.logging.Logger.error(ExceptionString,error);
	} catch (IOException error) {
		org.webdsl.logging.Logger.error(ExceptionString,error);
	}
  }
	  
  java.util.UUID sessionId = null;
  public java.util.UUID getSessionId(){
	  return sessionId;
  }
  protected java.util.UUID cookieValue = null;
  protected boolean mustRenewCookieValue = false;
  public void renewCookieValue(){
	  mustRenewCookieValue = true;
	  generateCookieValueAndPersist();
  }
  abstract public void generateCookieValueAndPersist();
  public String contextPath;
  protected String requested;
  public String getRequestedPage(){
    return requested;
  }
  
  protected static int httpsPort = 443;
  public int getHttpsPort(){ return httpsPort; }
  protected static int httpPort = 80;
  public int getHttpPort(){ return httpPort; }

  public String getContextPath() { return contextPath; }
  
  protected boolean disablePageCache = false;
  public void disablePageCache(){ //in custom routing, you can disable page cache
    disablePageCache = true;
  }
  
  protected void addToValues(String key, String val,Map<String, List<String>> parammapvalues){
	  List<String> current = parammapvalues.get(key); 
	  if(current==null){
		  List<String> newlist = new LinkedList<String>();
		  newlist.add(val);
		  parammapvalues.put(key,newlist) ; 
	  } else {
		  current.add(val);
      }
  }
    
  public boolean unspecifiedArgumentsContainEntityTypes(String[] argnames, int count){
	  Boolean[] argEntityTypes = pages.get(requested).getEntityArgs();
      for(int in = argnames.length-1; in >= count; in--){
    	  if(argEntityTypes[in] == true){
    		  return true;
    	  }
      }
      return false;
   }
    
  public String paramDecode(HttpServletRequest request, String param)  throws UnsupportedEncodingException {
	  String UTF8String = "UTF-8";
      if (request.getCharacterEncoding() != null && request.getCharacterEncoding().equals(UTF8String)) {
      } else {
    	  return new String(param.getBytes("ISO-8859-1"),UTF8String);
      }
      return param; 
  }
   
  protected static void cleanupThreadLocals(){
      ThreadLocalServlet.set(null);
  }

  //messages

  protected List<String> incomingSuccessMessages = new java.util.LinkedList<String>();

  public List<String> getIncomingSuccessMessages() {
    return incomingSuccessMessages;
  }
  
  public void clearSuccessMessages() {
    incomingSuccessMessages.clear();
    outgoingSuccessMessages.clear();
  }

  protected List<String> outgoingSuccessMessages = new java.util.LinkedList<String>();

  public List<String> getOutgoingSuccessMessages() {
    return outgoingSuccessMessages;
  }
  
  public abstract void storeOutgoingMessagesInHttpSession(boolean dropOldMessages);
  public abstract void retrieveIncomingMessagesFromHttpSession();
  
  // page dispatch custom routing
  protected String baseUrl;
  public String getBaseUrl(){
    return baseUrl;
  }
  protected List<String> urlComponents;
  public List<String> getUrlComponents(){
    return urlComponents;
  }
  
  public static final int maxRetries = utils.BuildProperties.getTransactionRetries();
  public int retries = 0;
}