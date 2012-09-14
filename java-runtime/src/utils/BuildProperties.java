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
    
    static {
        try {    
            props.load(BuildProperties.class.getResourceAsStream("/build.properties"));
            String requestlogprop = props.getProperty("webdsl.requestlog"); 
            if("true".equals(requestlogprop)){
                isRequestLoggingEnabled = true;
            }
            dbmode = props.getProperty("webdsl.DBMODE"); 
        }
        catch(java.io.FileNotFoundException fnf) {
            System.out.println("File \"build.properties\" not found");
        }
        catch(IOException io) {
            System.out.println("IOException while reading \"build.properties\"");   
        }
    }
    
}
