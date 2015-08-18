package org.webdsl.xml;

import java.util.Arrays;
import java.util.List;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.webdsl.logging.Logger;

public class XMLUtil{
	
	public static List<Node> getElementsByTagName( org.w3c.dom.Document doc, String tagName){
		return Arrays.asList(javaxt.xml.DOM.getElementsByTagName(tagName, doc));
	}
	public static List<Node> getElementsByTagName( org.w3c.dom.Node node, String tagName ){
		return Arrays.asList(javaxt.xml.DOM.getElementsByTagName(tagName, node));
	}
	public static String getText( org.w3c.dom.Node node, String tagName ){
		Node[] res = javaxt.xml.DOM.getElementsByTagName(tagName, node);
		if(res.length > 0){
			return javaxt.xml.DOM.getNodeValue(javaxt.xml.DOM.getElementsByTagName(tagName, node)[0]);
		} else {
			return "";
		}
	}	
	
	public static List<Node> getElementsByXPath( org.w3c.dom.Document doc, String xpath){
		return getElementsByXPath(doc.getDocumentElement(), xpath);        
	}
	public static List<Node> getElementsByXPath( Node n, String xpath){
		XPath xPath = XPathFactory.newInstance().newXPath();
		NodeList nodeList;
		java.util.ArrayList<Node> nodes = new java.util.ArrayList<Node>();
		try {
			nodeList = (NodeList)xPath.evaluate(xpath,
			        n, XPathConstants.NODESET);			
			for (int i=0; i<nodeList.getLength(); i++){
	            Node node = nodeList.item(i);
	            if (node.getNodeType()==1) nodes.add(node);
	        }
		} catch (XPathExpressionException e) {
			Logger.error(e);
		}
		return nodes;        
	}
}
