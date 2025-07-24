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
    
    enum DefaultCharSet{
        UTF8MB4,
        UTF8MB3
    }
    
    protected static DefaultCharSet defaultCharSet = DefaultCharSet.UTF8MB3;
    public static DefaultCharSet getDefaultCharSet(){
        return defaultCharSet;
    }
    
    protected static boolean wikitext_hardwraps = false;
    public static boolean isWikitextHardwrapsEnabled(){
      return wikitext_hardwraps;
    }
    
    protected static boolean wikitext_anchors = false;
    public static boolean isWikitextAnchorsEnabled(){
      return wikitext_anchors;
    }
    
    protected static int numcachedpages = 250; // default value, used for both anonymous and logged in page cache
    public static int getNumCachedPages(){
      return numcachedpages;
    }
    
    protected static int transactionRetries = 3;
    public static int getTransactionRetries(){
      return transactionRetries;
    }
    
    protected static String appUrlForRenderWithoutRequest;
    public static String getAppUrlForRenderWithoutRequest(){
        return appUrlForRenderWithoutRequest;
    }
    
    protected static int sessionExpirationHoursAfterLastUse = 180*24;
    public static int getSessionExpirationHoursAfterLastUse(){
      return sessionExpirationHoursAfterLastUse;
    }
    
    static {
        try {    
            props.load(BuildProperties.class.getResourceAsStream("/build.properties"));
            
            String requestlogprop = props.getProperty("webdsl.requestlog"); 
            if("true".equals(requestlogprop)){
                isRequestLoggingEnabled = true;
            }
            
            dbmode = props.getProperty("webdsl.DBMODE");

            String hardwraps = props.getProperty("webdsl.wikitext_hardwraps");
            if("true".equals(hardwraps)){
                wikitext_hardwraps = true; 
            }
            
            //use utf8mb3 as default for now
            String propCharSet = props.getProperty("webdsl.DEFAULTCHARSET", "utf8mb3").toLowerCase();
            defaultCharSet = "utf8mb4".equals(propCharSet) ? DefaultCharSet.UTF8MB4 : DefaultCharSet.UTF8MB3;
            org.webdsl.logging.Logger.info("Using '" + new MySQL5InnoDBDialectUTF8().getTableTypeString().trim() + "' for mysql table creation");
            
            
            String anchors = props.getProperty("webdsl.wikitext_anchors");
            if("true".equals(anchors)){
                wikitext_anchors = true; 
            }
            
            String numcached = props.getProperty("webdsl.numcachedpages");
            try{
                numcachedpages = Integer.parseInt(numcached);  
                org.webdsl.logging.Logger.info("numcachedpages: "+numcachedpages);
            }
            catch(NumberFormatException e){
                org.webdsl.logging.Logger.info("numcachedpages not specified, using: "+numcachedpages);
            }
            
            String retries = props.getProperty("webdsl.transactionretries");
            try{
                transactionRetries = Integer.parseInt(retries);  
                org.webdsl.logging.Logger.info("transactionretries: "+retries);
            }
            catch(NumberFormatException e){
                org.webdsl.logging.Logger.info("transactionretries not specified, using: "+transactionRetries);
            }
            
            String sessionExpHours = props.getProperty("webdsl.sessionexpirationhours");
            try{
                sessionExpirationHoursAfterLastUse = Integer.parseInt(sessionExpHours);
                org.webdsl.logging.Logger.info("sessionexpirationhours: "+ sessionExpHours + " (" + sessionExpirationHoursAfterLastUse / 24 + "d" + sessionExpirationHoursAfterLastUse % 24 + "h after last use)");
            }
            catch(NumberFormatException e){
                org.webdsl.logging.Logger.info("sessionexpirationhours not specified, using: "+ sessionExpirationHoursAfterLastUse + " (" + sessionExpirationHoursAfterLastUse / 24 + "d" + sessionExpirationHoursAfterLastUse % 24 + "h)");
            }
            
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
