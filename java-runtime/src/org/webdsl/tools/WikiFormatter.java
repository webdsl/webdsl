package org.webdsl.tools;


import java.util.regex.Pattern;

import org.jsoup.safety.Whitelist;
import org.webdsl.logging.Logger;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.vladsch.flexmark.ast.AutoLink;
import com.vladsch.flexmark.ast.HtmlBlock;
import com.vladsch.flexmark.ast.HtmlInline;
import com.vladsch.flexmark.ast.Link;
import com.vladsch.flexmark.ast.Node;
import com.vladsch.flexmark.ext.wikilink.WikiLinkExtension;
import com.vladsch.flexmark.html.AttributeProvider;
import com.vladsch.flexmark.html.AttributeProviderFactory;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.html.IndependentAttributeProviderFactory;
import com.vladsch.flexmark.html.renderer.AttributablePart;
import com.vladsch.flexmark.html.renderer.NodeRendererContext;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.profiles.pegdown.Extensions;
import com.vladsch.flexmark.profiles.pegdown.PegdownOptionsAdapter;
import com.vladsch.flexmark.util.html.Attributes;
import com.vladsch.flexmark.util.options.MutableDataHolder;
import com.vladsch.flexmark.util.options.MutableDataSet;

import utils.AbstractPageServlet;
import utils.BuildProperties;
import utils.HTMLFilter;


public final class WikiFormatter {
	
//    private static final Pattern verbatim = Pattern.compile("<verbatim>(.+?)</verbatim>", Pattern.DOTALL | Pattern.MULTILINE);
    private static String currentRootUrl = "";
//    private static LinkRenderer currentLinkRenderer = null;
    private static final Whitelist whitelist = org.jsoup.safety.Whitelist.relaxed();
    public static final Pattern DISABLE_HARDWRAPS_PATTERN = Pattern.compile("^<!--(DISABLE_HARDWRAPS|NO_HARDWRAPS)-->", Pattern.CASE_INSENSITIVE);
    private static MutableDataSet optionsNoHardWraps;
    private static MutableDataSet optionsHardWraps;
    private static Parser MARKDOWN_PARSER = null;
    private static HtmlRenderer RENDERER_NOHW = null;
    private static HtmlRenderer RENDERER_HW = null;
    
	static{
		whitelist.addTags("abbr", "hr", "del", "details", "summary")
		         .addAttributes("abbr", "title")
		         .addAttributes("th", "align")
		         .addAttributes("td", "align")
		         .addAttributes("code", "class")
		         .addAttributes("div", "class")
		         .addAttributes("a", "rel")
             .addAttributes("details", "class")
             .addAttributes("details", "open");
		//allow id's on title tags
		for(int i=1;i<7;i++){
			whitelist.addAttributes("h"+i, "id");
		}
		whitelist.addProtocols("a", "href", "#");
		whitelist.addEnforcedAttribute("a", "rel", "nofollow");
		
		MutableDataSet defaultOptions = new MutableDataSet( PegdownOptionsAdapter.flexmarkOptions(true, Extensions.ALL & ~Extensions.HARDWRAPS & ~Extensions.ANCHORLINKS) );
		defaultOptions.set(WikiLinkExtension.LINK_PREFIX, "");
		defaultOptions.set(HtmlRenderer.FENCED_CODE_LANGUAGE_CLASS_PREFIX, "line-numbers language-");

		/*
		 * rel=no-follow is handled by jsoup for now (so it does not apply to unsafe wikitexts) For more finer grained behavior, e.g. only adding rel="no-follow" to external links,
		 * we probably need to process links in the markdown parser/renderer, which works like below, but not yet for links entered as HTML (<a href...) in the markdown source,
		 * see https://github.com/vsch/flexmark-java/issues/277
		 */		
     // //add rel="nofollow" attribute to link nodes (from examples mentioned in https://github.com/vsch/flexmark-java/issues/103) 
     // Parser.addExtensions(defaultOptions, AttributeProviderExtension.create());

		//defaultOptions.set(Parser.BLOCK_QUOTE_INTERRUPTS_PARAGRAPH, false); //Workaround for https://github.com/vsch/flexmark-java/issues/101 Blockquotes should now start after blank line
		optionsNoHardWraps = new MutableDataSet( defaultOptions );		
		optionsHardWraps = new MutableDataSet( defaultOptions );
		optionsHardWraps.set(HtmlRenderer.SOFT_BREAK, "<br/>");
		MARKDOWN_PARSER = Parser.builder( optionsNoHardWraps ).build();
		RENDERER_NOHW = HtmlRenderer.builder( optionsNoHardWraps ).build();
		RENDERER_HW = HtmlRenderer.builder( optionsHardWraps ).build();

		
	}

	public static CacheLoader<String, String> loader =
			new CacheLoader<String, String>() {
		public String load(String text) {
			AbstractPageServlet threadLocalPage = utils.ThreadLocalPage.get();
			boolean useHardWraps = BuildProperties.isWikitextHardwrapsEnabled() && !(text!=null && DISABLE_HARDWRAPS_PATTERN.matcher(text).find() );
			return wikiFormat( text, useHardWraps, threadLocalPage.getAbsoluteLocation() );
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
    
    public static String wikiFormat(String text, boolean useHardWraps, String rootUrl){
    	try {
            Node document = MARKDOWN_PARSER.parse( text );
            HtmlRenderer renderer = getHTMLRenderer(rootUrl, useHardWraps);
            return renderer.render(document);
//            		 + "<!--end-->"; //This forces an unclosed HTML-comment in the rendered output to be closed. This fixes the issue where commonmark may escape a closing `-->` when a blank line exists in the HTML comment.  
//    		return processor.markdownToHtml( processVerbatim(text), getLinkRenderer( rootUrl ) );
    	} catch (Exception e) {
			Logger.error(e);
			return errorMessage(text);
		}
    }    
    
    private static String errorMessage( String text ){
    	StringBuilder sb = new StringBuilder(text.length() + 128);
    	sb.append("Something went wrong processing the following markdown text: ")
    	  .append("<pre>")
    	  .append( HTMLFilter.filter(text) )
    	  .append("</pre>");
    	return sb.toString();
    }

	// private static String processVerbatim(String text) {
	// Matcher m = verbatim.matcher(text);
	// if (m.find()){
	// StringBuffer sb = new StringBuffer( text.length() + 256 );
	// do {
	// String newText = "\n " +
	// m.group(1).replaceAll("\n", "\n ")
	// .replaceAll("\\\\", "\\\\\\\\")
	// .replaceAll("\\$", "\\\\\\$") +
	// "\n";
	// m.appendReplacement(sb, newText);
	//
	// } while (m.find());
	// m.appendTail(sb);
	// return sb.toString();
	// } else {
	// return text;
	// }
	// }
    
    private static synchronized HtmlRenderer getHTMLRenderer( String rootUrl, boolean hardwrapsEnabled ){
    	if(!currentRootUrl.equals(rootUrl) && rootUrl != null ) {
			currentRootUrl = rootUrl;
			RENDERER_HW = null;
			RENDERER_NOHW = null;
			String linkPrefix = rootUrl + "/";
			optionsHardWraps.set(WikiLinkExtension.LINK_PREFIX, linkPrefix);
			optionsNoHardWraps.set(WikiLinkExtension.LINK_PREFIX, linkPrefix);
		}
    	
    	if(hardwrapsEnabled){
    		if(RENDERER_HW == null){    			
    			RENDERER_HW = HtmlRenderer.builder( optionsHardWraps ).build();
    		}
    		return RENDERER_HW;
    	} else {
    	    if(RENDERER_NOHW == null){
    	    	RENDERER_NOHW = HtmlRenderer.builder( optionsNoHardWraps ).build();
    	    }
    	    return RENDERER_NOHW;
    	}
    }

//    public static void main(String[] args) {
//        System.out.println("The output:");
//        System.out
//                .println(wikiFormat("This is a header\n=========\n\nAnd here's a link [[page(MainPage)|Main page]].\nHello people! [[home()]] -- [[home|Terug naar de homepage]]\n\nHere is some verbatim:\n<verbatim>Dit is een test <hoi>. Enzovoorts\nBlabla\n\n  Free $$$ for all!</verbatim>Doei.", true, "/test") );
//    }
    
    

// //Flexmark extension classes used for adding rel="nofollow" attribute to links    
//  static class AttributeProviderExtension implements HtmlRenderer.HtmlRendererExtension {
//      @Override
//      public void rendererOptions(final MutableDataHolder options) {
//          // add any configuration settings to options you want to apply to everything, here
//      }
//
//      @Override
//      public void extend(final HtmlRenderer.Builder rendererBuilder, final String rendererType) {
//          rendererBuilder.attributeProviderFactory(WikiLinkAttributeProvider.Factory());
//      }
//
//      static AttributeProviderExtension create() {
//          return new AttributeProviderExtension();
//      }
//  }
//
//  static class WikiLinkAttributeProvider implements AttributeProvider {
//        @Override
//        public void setAttributes(final Node node, final AttributablePart part, final Attributes attributes) {
//            if ( (node instanceof Link || node instanceof AutoLink /*|| node instanceof ???? */)
//                 && (part == AttributablePart.LINK) ) {
//              attributes.replaceValue("rel", "nofollow"); //this also adds the attribute when missing
//            }
//        }
//  
//        static AttributeProviderFactory Factory() {
//            return new IndependentAttributeProviderFactory() {
//                @Override
//                public AttributeProvider create(NodeRendererContext arg0) {
//                  return new WikiLinkAttributeProvider();
//                }
//            };
//        }
//    }
}