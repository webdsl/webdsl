package utils;

import java.io.IOException;

public class BuildProperties {

    protected static java.util.Properties props = new java.util.Properties();
    protected static boolean isRequestLoggingEnabled = false; // no logging of requests in the database is the default
    
    public static boolean isRequestLoggingEnabled(){
        return isRequestLoggingEnabled;
    }
    
    protected static String dbmode;
    public static String getDbMode(){
        return dbmode;
    }
    
    protected static String appUrlForRenderWithoutRequest;
    public static String getAppUrlForRenderWithoutRequest(){
        return appUrlForRenderWithoutRequest;
    }
    
    static {
        try {    
            props.load(BuildProperties.class.getResourceAsStream("/build.properties"));
            String requestlogprop = props.getProperty("webdsl.requestlog"); 
            if("true".equals(requestlogprop)){
                isRequestLoggingEnabled = true;
            }
            dbmode = props.getProperty("webdsl.DBMODE");
            setAppUrlForRenderWithoutRequest();            
            
        }
        catch(java.io.FileNotFoundException fnf) {
            org.webdsl.logging.Logger.error("File \"build.properties\" not found");
        }
        catch(IOException io) {
            org.webdsl.logging.Logger.error("IOException while reading \"build.properties\"");   
        }
    }
    
    private static void setAppUrlForRenderWithoutRequest(){
    	appUrlForRenderWithoutRequest = props.getProperty("webdsl.appurlforrenderwithoutrequest");
        if (appUrlForRenderWithoutRequest == null || appUrlForRenderWithoutRequest.isEmpty()){
        	appUrlForRenderWithoutRequest = null;
        } else {
        	appUrlForRenderWithoutRequest = appUrlForRenderWithoutRequest.trim();
        	while( appUrlForRenderWithoutRequest.endsWith( "/" ) )
        		appUrlForRenderWithoutRequest = appUrlForRenderWithoutRequest.substring( 0, appUrlForRenderWithoutRequest.length()-1 );
        }
    }
    
    
}
