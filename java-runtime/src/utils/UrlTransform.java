package utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UrlTransform {
    
    public static String convertToHttpsUrl(String s){
        return urlConvertHelper(s, "https", ThreadLocalServlet.get().getHttpsPort(), 443);
    }
    
    public static String convertToHttpUrl(String s){
        return urlConvertHelper(s, "http", ThreadLocalServlet.get().getHttpPort(), 80);
    }
    
    public static String p1 = "http[s]?://([^/]*)/(.*)"; 
    public static String p2 = "([^:]*):(.)*"; 
    public static Pattern pattern1 = Pattern.compile(p1); 
    public static Pattern pattern2 = Pattern.compile(p2); 
    
    public static String urlConvertHelper(String input, String protocol, int port, int defaultport){
        String result = input;
        //System.out.println("before: "+result);
        Matcher matcher = pattern1.matcher(input); 
        boolean matchFound = matcher.matches(); 
        if (matchFound) { 
            String domain = matcher.group(1);
            //System.out.println("domain: "+domain);
            String rest = matcher.group(2);
            //System.out.println("rest: "+rest);
            Matcher dmatcher = pattern2.matcher(domain); 
            boolean dmatchFound = dmatcher.find();
            if(dmatchFound){
                result = protocol+"://"+dmatcher.group(1);
            }
            else{
                result = protocol+"://"+domain;
            }
            result += ( port == defaultport ? "" : ":"+port )+"/"+rest;
        } 
        else{
            utils.Warning.warn("URL to "+protocol+" conversion failed for: "+input);
        }
        //System.out.println("after: "+result);
        return result;
    }

}