package org.webdsl.tools;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.pegdown.LinkRenderer;
import org.pegdown.ast.WikiLinkNode;

public class WebDSLLinkRenderer extends LinkRenderer {
	
	private static final Pattern LINKS = Pattern.compile("(\\w+)(\\(([^\\)]*)\\))?(\\|([^\\]]+))?");
	private static final String QUOTE = "\"";
	private static final String URLQUOTE = "%22";	
	private String rootUrl;
	
	public WebDSLLinkRenderer(String rootUrl){
		this.rootUrl = rootUrl;
	}
	
    public Rendering render(WikiLinkNode node) {
        Matcher m = LINKS.matcher(node.getText());
        String url, title;
        if(m.find()) {
            if(m.group(2) == null || m.group(3).length() == 0) {
                url = rootUrl + "/" + m.group(1);
                title = m.group(1);
            } else {
                url = rootUrl + "/" + m.group(1) + "/" + m.group(3).replace(' ', '+');
                title = m.group(3);
            }
            if(m.group(5) != null) {
                title = m.group(5);
            }            
        } else { //fallback
        	url = rootUrl + "/" + node.getText();
        	title = node.getText();
        }
        //Don't allow String breaking in the href argument 
        url = url.replace(QUOTE, URLQUOTE);        
        return new Rendering(url, title);
    }

}
