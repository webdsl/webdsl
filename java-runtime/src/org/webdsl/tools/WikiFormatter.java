package org.webdsl.tools;


import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.safety.Whitelist;
import org.pegdown.LinkRenderer;
import org.pegdown.PegDownProcessor;
import org.webdsl.logging.Logger;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;

import utils.AbstractPageServlet;
import utils.BuildProperties;


public final class WikiFormatter {
	
    private static final Pattern verbatim = Pattern.compile("<verbatim>(.+?)</verbatim>", Pattern.DOTALL | Pattern.MULTILINE);
    private static String currentRootUrl = "";
    private static LinkRenderer currentLinkRenderer = null;
    private static final Whitelist whitelist = org.jsoup.safety.Whitelist.relaxed();
    public static final int PARSE_TIMEOUT_MS = 6000;
    public static final Pattern DISABLE_HARDWRAPS_PATTERN = Pattern.compile("^<!--(DISABLE_HARDWRAPS|NO_HARDWRAPS)-->", Pattern.CASE_INSENSITIVE);
    
	static{
		whitelist.addTags("abbr", "hr", "del")
		         .addAttributes("abbr", "title")
		         .addAttributes("th", "align")
		         .addAttributes("td", "align")
		         .addAttributes("code", "class");
		//allow id's on title tags
		for(int i=1;i<7;i++){
			whitelist.addAttributes("h"+i, "id");
		}
	}

	public static CacheLoader<String, String> loader =
			new CacheLoader<String, String>() {
		public String load(String text) {
			AbstractPageServlet threadLocalPage = utils.ThreadLocalPage.get();
			if( !BuildProperties.isWikitextHardwrapsEnabled() || (text!=null && DISABLE_HARDWRAPS_PATTERN.matcher(text).find() )){
				return wikiFormat( text, threadLocalPage.getPegDownProcessorNoHardWraps(), threadLocalPage.getAbsoluteLocation() );
			} else {
				return wikiFormat( text, threadLocalPage.getPegDownProcessor(), threadLocalPage.getAbsoluteLocation() );
			}			
		}
	};

	public static LoadingCache<String, String> cache =
			CacheBuilder.newBuilder()
			.maximumSize(250)
			.build(loader);

    public static String wikiFormat(String text) {
    	if ( text == null )
    		return "";
    	return org.jsoup.Jsoup.clean(cache.getUnchecked(text), whitelist );
    }
    
    //Similar to wikiFormat( text ) , but without cleaning by JSoup
    public static String wikiFormatNoTagFiltering(String text) {
    	if ( text == null )
    		return "";
    	return cache.getUnchecked(text);
    }
    
    public static String wikiFormat(String text, PegDownProcessor processor, String rootUrl){
    	
    	try {
    		return processor.markdownToHtml( processVerbatim(text), getLinkRenderer( rootUrl ) );
    	} catch (Exception e) {
			Logger.error(e);
			return errorMessage(text);
		}
    }    
    
    private static String errorMessage( String text ){
    	StringBuilder sb = new StringBuilder(text.length() + 128);
    	sb.append("Something went wrong processing the following markdown text (parsing automatically stopped after ")
    	  .append(PARSE_TIMEOUT_MS)
    	  .append("ms): ")
    	  .append("<pre>")
    	  .append(text)
    	  .append("</pre>");
    	return sb.toString();
    }

    private static String processVerbatim(String text) {
        Matcher m = verbatim.matcher(text);
        if (m.find()){
        	StringBuffer sb = new StringBuffer( text.length() + 256 );
        	do {
        		String newText = "\n        " +
                        m.group(1).replaceAll("\n", "\n        ")
                                  .replaceAll("\\\\", "\\\\\\\\")
                                  .replaceAll("\\$", "\\\\\\$") +
                        "\n";
                m.appendReplacement(sb, newText);
        		
        	} while (m.find());
        	m.appendTail(sb);
        	return sb.toString();
        } else {
        	return text;
        }
    }
    
    private static synchronized LinkRenderer getLinkRenderer( String rootUrl ){
    	if(!currentRootUrl.equals(rootUrl) && rootUrl != null ) {
			currentRootUrl = rootUrl;
			currentLinkRenderer = new WebDSLLinkRenderer(rootUrl);
		}
    	return currentLinkRenderer;
    }

//    public static void main(String[] args) {
//        System.out.println("The output:");
//        System.out
//                .println(wikiFormat("This is a header\n=========\n\nAnd here's a link [[page(MainPage)|Main page]].\nHello people! [[home()]] -- [[home|Terug naar de homepage]]\n\nHere is some verbatim:\n<verbatim>Dit is een test <hoi>. Enzovoorts\nBlabla\n\n  Free $$$ for all!</verbatim>Doei.", "/test"));
//    }
    

}