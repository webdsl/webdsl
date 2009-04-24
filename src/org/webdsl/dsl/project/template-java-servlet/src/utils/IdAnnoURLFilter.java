package utils;

/**
 *  
 * Custom encoding of problematic characters in URLs
 *
 */

public final class IdAnnoURLFilter {

	public static String filter(String message) {
        if (message == null)
            return (null);
        char content[] = new char[message.length()];
        message.getChars(0, message.length(), content, 0);
        StringBuffer result = new StringBuffer(content.length + 50);
        for (int i = 0; i < content.length; i++) {
            switch (content[i]) {
            case '?':
                result.append("^qm");
                break;
            case '/':
                result.append("^s");
                break;
            case '\\':
                result.append("^b");
                break;
            case '#':
            	result.append("^p");
                break;
            case '^':
            	result.append("^^");
            	break;
            default:
                result.append(content[i]);
            }
        }
        return (result.toString());
    }
	public static String unfilter(String message) {
		if (message == null)
			return (null);
		return message.replaceAll("\\^qm","?")
		  .replaceAll("\\^s","/")
		  .replaceAll("\\^b",java.util.regex.Matcher.quoteReplacement("\\")) //special case for backslash, see javadocs for String.replaceAll
		  .replaceAll("\\^p","#")
		  .replaceAll("\\^\\^","^"); //the escape character, picked ^ because it is probably not used a lot in URLs
	}
}

