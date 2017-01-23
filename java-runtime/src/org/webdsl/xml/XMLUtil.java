package org.webdsl.xml;

import java.util.Arrays;
import java.util.List;

import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.hamcrest.core.IsAnything;
import org.w3c.dom.DOMException;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.webdsl.logging.Logger;

import java.io.*;


public class XMLUtil{
	
	public static String asString( org.w3c.dom.Document doc){
	    try
	    {
	       DOMSource domSource = new DOMSource(doc);
	       StringWriter writer = new StringWriter();
	       StreamResult result = new StreamResult(writer);
	       TransformerFactory tf = TransformerFactory.newInstance();
	       Transformer transformer = tf.newTransformer();
	       transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	       transformer.transform(domSource, result);
	       return writer.toString();
	    }
	    catch(TransformerException ex)
	    {
	       ex.printStackTrace();
	       return null;
	    }
	}
	
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
	private final static short ANYNODE = -10;
	
	public static List<Node> getElementsByXPath( org.w3c.dom.Document doc, String xpath){
		return getNodesByXPath(doc.getDocumentElement(), xpath, org.w3c.dom.Node.ELEMENT_NODE);        
	}
	public static List<Node> getNodesByXPath( org.w3c.dom.Document doc, String xpath){
		return getNodesByXPath(doc.getDocumentElement(), xpath, ANYNODE);
	}
	public static List<Node> getElementsByXPath( Node n, String xpath){
	  return getNodesByXPath(n, xpath, org.w3c.dom.Node.ELEMENT_NODE);
	}
	public static List<Node> getNodesByXPath( Node n, String xpath){
		return getNodesByXPath(n, xpath, ANYNODE);
	}
	public static List<Node> getNodesByXPath( Node n, String xpath, short nodeType){
		XPath xPath = XPathFactory.newInstance().newXPath();
		NodeList nodeList;
		java.util.ArrayList<Node> nodes = new java.util.ArrayList<Node>();
		try {
			nodeList = (NodeList)xPath.evaluate(xpath,
			        n, XPathConstants.NODESET);			
			for (int i=0; i<nodeList.getLength(); i++){
	            Node node = nodeList.item(i);
	            if (nodeType == ANYNODE || node.getNodeType()==nodeType) nodes.add(node);
	        }
		} catch (XPathExpressionException e) {
			Logger.error(e);
		}
		return nodes;        
	}
	
	//Explore XML
	public static List<Node> getAttributes( org.w3c.dom.Node node){
		NamedNodeMap attrs = node.getAttributes();
		List<Node> attributeNodes = new java.util.ArrayList<Node>();
		if(attrs != null){
			for(int idx = 0; idx<attrs.getLength() ; idx++){
				attributeNodes.add(attrs.item(idx));
			}
		}
		return attributeNodes;
	}
	
	public static List<Node> getChildren( org.w3c.dom.Node parent ){
		NodeList nodeList = parent.getChildNodes();
		java.util.ArrayList<Node> nodes = new java.util.ArrayList<Node>();
		
		for (int i=0; i<nodeList.getLength(); i++){
			Node node = nodeList.item(i);
            if (node.getNodeType()==org.w3c.dom.Node.ELEMENT_NODE){
              nodes.add(node);
            }
		}
		return nodes;
	}
	
	public static void setValue( org.w3c.dom.Node n, String val){
		try{
			if(n.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE){
				n.setTextContent(val);
			} else {
				n.setNodeValue(val);
			}
		} catch(DOMException ex){
			Logger.error(ex);
		}
	}
}
