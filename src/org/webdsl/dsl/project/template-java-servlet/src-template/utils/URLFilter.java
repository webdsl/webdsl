package utils;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Pattern;

import org.apache.lucene.search.regex.RegexCapabilities;

/**
 *  
 * Custom encoding of problematic characters in URLs
 * 
 * Tomcat blocks %2F, %5C and '\' by default (encoded slash and encoded/unencoded backslash)
 * 
 * https://www.covalent.net/download/patch2.0/README-ers-3.1.0-patch-tomcat-20070315.txt
 *
 * The issue is related to access control managed by tomcat, which is not used by WebDSL applications.
 * However, it is more convenvient to solve with a custom escape here, than enabling these characters in tomcat.
 * 
 * 
 */


public final class URLFilter {
	public static final String encoding = "UTF-8";

	public static String filter(boolean message) {
		return filter(String.valueOf(message));
	}
	public static String filter(int message) {
		return filter(String.valueOf(message));
	}
	public static String filter(float message) {
		return filter(String.valueOf(message));
	}
	public static String filter(String message) {
		if (message == null)
			return (null);
		try{
			char content[] = new char[message.length()];
			message.getChars(0, message.length(), content, 0);
			StringBuffer result = new StringBuffer(content.length + 50);
			for (int i = 0; i < content.length; i++) {
				switch (content[i]) {
				case '/':
					result.append("^s");
					break;
				case '\\':
					result.append("^b");
					break;
				case '^':
					result.append("^^");
					break;
				default:
					result.append(content[i]);
				}
			}
			return java.net.URLEncoder.encode(result.toString(),encoding);
		}
		catch(java.io.UnsupportedEncodingException e){
			e.printStackTrace();
			return null;
		}
	}	
	public static Map<String,String> URLEncodingToParamMap(String paramMapAsStr){
		Map<String, String> map = new HashMap<String, String>();
		String[] urlParts = paramMapAsStr.split("&");
		String[] kv;
		for (String str : urlParts) {
			kv = str.split("=", 2);
			map.put(unescapeParamMapEntry(kv[0]),unescapeParamMapEntry(kv[1]));
		}
		return map;
		
	}	
	
	public static String paramMapToURLEncoding(Map<String,String> paramMap){
		StringBuilder sb = new StringBuilder();
		for (Entry<String,String> e : paramMap.entrySet()) {
			sb.append(filter(escapeParamMapEntry(e.getKey())));
			sb.append("=");
			sb.append(filter(escapeParamMapEntry(e.getValue())));
			sb.append("&");
		}
		return sb.toString();
	}
	
	public static String paramMapToPostParamsEncoding(Map<String,String> paramMap){
		StringBuilder sb = new StringBuilder();
		for (Entry<String,String> e : paramMap.entrySet()) {
			sb.append(escapeParamMapEntry(e.getKey()));
			sb.append("=");
			sb.append(escapeParamMapEntry(e.getValue()));
			sb.append("&");
		}
		return sb.toString();
	}
	
	public static String escapeParamMapEntry(String pme){
		return pme.replaceAll("\\\\", "\\\\\\\\ ").replaceAll("\\&", "\\\\a").replaceAll("=", "\\\\e");
	}
	public static String unescapeParamMapEntry(String pme){
		return pme.replaceAll("\\\\e","=").replaceAll("\\\\a", "&").replaceAll("\\\\\\\\ ", "\\\\");
	}

	
	public static String unfilter(String message) {

		if (message == null)
			return (null);
		try{
			//UTF-8 encoding seems to be send but interpreted as latin-1 encoding in java code 
			String newmessage = new String(message.getBytes("ISO-8859-1"), "UTF-8");

			//general decode of URL
			newmessage = java.net.URLDecoder.decode(newmessage, encoding);

			//decode custom escapes
			return newmessage
			.replaceAll("\\^s","/")
			.replaceAll("\\^b",java.util.regex.Matcher.quoteReplacement("\\")) //special case for backslash, see javadocs for String.replaceAll
			.replaceAll("\\^\\^","^"); //the escape character, picked ^ because it is probably not used a lot in URLs
		} 
		catch(java.io.UnsupportedEncodingException e){
			e.printStackTrace();
			return null;
		}

	}
	
    public static String removeTrailingDefaultValues(String s, String... strings){
    	String[] parts = s.split("/");
    	
    	//remove trailing default values
    	int i = 0;
    	for(i = parts.length - 1; i >= 0; i--){
    		if( !(parts[i].equals("") && utils.TypesInfo.getStringCompatibleTypes().contains(strings[i]))
    				&& !(parts[i].equals("0") && strings[i].equals("Int"))
    				&& !(parts[i].equals("0.0") && strings[i].equals("Float"))
    		){
    			break;
    		}
    	}
        
        //make one string for URL
    	StringBuffer sb = new StringBuffer();
    	for(int j = 0; j <= i; j++){
    		sb.append("/");
    		sb.append(parts[j]);
    	}
    	return sb.toString();
    }
}
