package utils;

public final class HTMLFilter {

    /**
     * HTML filter utility from tomcat utils with a reverse added.
	 *
	 * @author Craig R. McClanahan
	 * @author Tim Tye
	 * @version $Revision: 467217 $ $Date: 2006-10-24 05:14:34 +0200 (Tue, 24 Oct 2006) $
	 * 
     * Filter the specified message string for characters that are sensitive
     * in HTML.  This avoids potential attacks caused by including JavaScript
     * codes in the request URL that is often reported in error messages.
     *
     * @param message The message string to be filtered
     */
    public static String filter(String message) {

        if (message == null)
            return (null);

        char content[] = new char[message.length()];
        message.getChars(0, message.length(), content, 0);
        StringBuffer result = new StringBuffer(content.length + 50);
        for (int i = 0; i < content.length; i++) {
            switch (content[i]) {
            case '<':
                result.append("&lt;");
                break;
            case '>':
                result.append("&gt;");
                break;
            case '&':
                result.append("&amp;");
                break;
            case '"':
                result.append("&quot;");
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
		return message
		  .replaceAll("&lt;","<")
		  .replaceAll("&gt;",">")
		  .replaceAll("&amp;","&")
		  .replaceAll("&quot;","\"");
	}    
    

}

