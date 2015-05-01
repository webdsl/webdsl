package utils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TemplateCall {

   public TemplateCall(boolean valid, String name, Object[] args, Map<String,String> attrs){
      this.valid = valid;
      this.name = name;
      this.args = args;
      this.attrs = attrs;
  }

   public TemplateCall(String name, String parentName, Object[] args, Map<String,String> attrs){
       this.valid = true;
       this.name = name;
       this.args = args;
       this.attrs = attrs;
       this.parentName = parentName;
   }

   public TemplateCall(String name, Object[] args, Map<String,String> attrs){
       this.valid = true;
       this.name = name;
       this.args = args;
       this.attrs = attrs;
   }

  public TemplateCall(boolean valid, String name, Object[] args){
      this.valid = valid;
      this.name = name;
      this.args = args;
  }

  public TemplateCall(String name, Object[] args){
      this.valid = true;
      this.name = name;
      this.args = args;
  }

  public static TemplateCall None = new TemplateCall(false, "", new Object[0]);

  public static Map<String, utils.TemplateCall> NoWithCalls = new HashMap<String, utils.TemplateCall>();

  public boolean valid;
  public String name;
  public Object[] args;
  public Map<String,String> attrs;
  public String parentName; //name of template being called with this TemplateCall as argument

  public static final Map<String, String> EmptyAttrs = new HashMap<String, String>();
  public static final List<String> EmptyExceptList = new ArrayList<String>();
  @SuppressWarnings("serial")
  public static final List<String> listStringWithClassAndStyle = new java.util.ArrayList<String>(2){{ add("class"); add("style"); }};
  
  
  /*
   *  just the value of the attribute, no escaping
   */

  public static String getAttribute(Map<String,String> attrs, String key, String def) {
    String s = getAttribute(attrs,key);
    if (s.equals("")){
        return def;
    }
    else{
        return s;
    }
  }
  public static String getAttribute(Map<String,String> attrs, String key) {
      if (attrs == null){ return ""; }
      if(attrs.containsKey(key)){
          return attrs.get(key);
      }
      return "";
  }


  /*
   *  whole attribute declaration, with escaping
   */

  public static String getAllAttributes(Map<String,String> attrs) {
      return getAllAttributesExcept(attrs,EmptyExceptList);
  }

  public static String getAllAttributesExcept(Map<String,String> attrs, String except) {
      List<String> list = new ArrayList<String>();
      list.add(except);
      return getAllAttributesExcept(attrs,list);
  }
  public static String getAllAttributesExcept(Map<String,String> attrs, Collection<String> exceptlist) {
      if (attrs == null){ return ""; }
      else{
          StringBuilder sb = new StringBuilder(attrs.size()*128+32);
          for(String key : attrs.keySet()){
              if(!exceptlist.contains(key) && !ignoredAttributeByDefault(key)){
                  sb.append(org.webdsl.tools.Utils.showAttributeEscapeHtml(key,attrs.get(key)));
              }
          }
          return sb.toString();
      }
  }

  public static String getAttributes(Map<String,String> attrs, String selected) {
    return org.webdsl.tools.Utils.showAttributeEscapeHtml(selected,getAttribute(attrs,selected));
  }
  public static String getAttributes(Map<String,String> attrs, Collection<String> selected) {
      if (attrs == null){ return ""; }
      else{
          StringBuilder sb = new StringBuilder(256);
          for(String key : selected){
              if(attrs.containsKey(key)){
                  sb.append(org.webdsl.tools.Utils.showAttributeEscapeHtml(key,attrs.get(key)));
              }
          }
          return sb.toString();
      }
  }

  
  /*
   *  just filter, used when passing attributes through template calls
   */
  
  public static void filterAllAttributesExcept(Map<String,String> attrs, Map<String,String> attrsmapout, String except) {
      List<String> list = new ArrayList<String>();
      list.add(except);
      filterAllAttributesExcept(attrs, attrsmapout, list);
  }
  public static void filterAllAttributesExcept(Map<String,String> attrs, Map<String,String> attrsmapout, Collection<String> exceptlist) {
      if (attrs != null){
          for(String key : attrs.keySet()){
              if(!exceptlist.contains(key)){
            	  putAttributeMergeClassOrStyle(attrsmapout, key, attrs.get(key));
              }
          }
      }
  }
  
  public static void filterAttributes(Map<String,String> attrs, Map<String,String> attrsmapout, String selected) {
      if(attrs.containsKey(selected)){
    	  attrsmapout.put(selected, attrs.get(selected));
      }
  }
  public static void filterAttributes(Map<String,String> attrs, Map<String,String> attrsmapout, Collection<String> selected) {
      if (attrs != null){
          for(String key : selected){
              if(attrs.containsKey(key)){
            	  putAttributeMergeClassOrStyle(attrsmapout, key, attrs.get(key));
              }
          }
      }
  }
  
  public static void putAllAttributeMergeClassOrStyle(Map<String,String> attrs, Map<String,String> attrsmapout){
	  if(attrs != null){
		  for(String key : attrs.keySet()){
			  putAttributeMergeClassOrStyle(attrsmapout, key, attrs.get(key));
		  }
	  }
  }
  
  public static void putAttributeMergeClassOrStyle(Map<String,String> attrsmapout, String key, String value){
	  String old;
	  if((key.equals("class") || key.equals("style")) && ((old = attrsmapout.get(key)) != null)){
		  attrsmapout.put(key, old + " " + value);
	  }
	  else{
		  attrsmapout.put(key, value);
	  }
  }
  public static void putAttributeMergeClassOrStyle(Map<String,String> attrsmapout, String key, Integer value){
	  putAttributeMergeClassOrStyle(attrsmapout, key, value.toString());
  }
  
  
  /*
   *  utility methods for handling class and style attribute merging when displaying attributes in tag rendering
   */
  
  public static void handleAttrsAtHtmlElement(Map<String,String> attrs, StringBuilder classAttr, StringBuilder styleAttr, java.util.List<String> ignore, java.io.PrintWriter out){
	  if(attrs != null){		
	      String c = attrs.get("class");
	      if(c != null){
	    	  appendWithPadding(classAttr, c);
	      }
	      String s = attrs.get("style");
	      if(s != null){
	    	  appendWithPadding(styleAttr, s);
	      }
	      out.print(getAllAttributesExcept(attrs, listStringWithClassAndStyle));
      }
  }
  public static void handleAttrsAtHtmlElementExcept(String except, Map<String,String> attrs, StringBuilder classAttr, StringBuilder styleAttr, java.util.List<String> ignore, java.io.PrintWriter out){
	  if(attrs == null) return;
	  Map<String,String> newattrs = new HashMap<String,String>();
	  filterAllAttributesExcept(attrs, newattrs, except);
	  handleAttrsAtHtmlElement(newattrs, classAttr, styleAttr, ignore, out);
  }
  public static void handleAttrsAtHtmlElementExcept(Collection<String> exceptlist, Map<String,String> attrs, StringBuilder classAttr, StringBuilder styleAttr, java.util.List<String> ignore, java.io.PrintWriter out){
	  if(attrs == null) return;
	  Map<String,String> newattrs = new HashMap<String,String>();
	  filterAllAttributesExcept(attrs, newattrs, exceptlist);
	  handleAttrsAtHtmlElement(newattrs, classAttr, styleAttr, ignore, out);
  }
  public static void handleAttrsAtHtmlElementSelect(String selected, Map<String,String> attrs, StringBuilder classAttr, StringBuilder styleAttr, java.util.List<String> ignore, java.io.PrintWriter out){
	  if(attrs == null) return;
	  Map<String,String> newattrs = new HashMap<String,String>();
	  filterAttributes(attrs, newattrs, selected);
	  handleAttrsAtHtmlElement(newattrs, classAttr, styleAttr, ignore, out);
  }
  public static void handleAttrsAtHtmlElementSelect(Collection<String> selected, Map<String,String> attrs, StringBuilder classAttr, StringBuilder styleAttr, java.util.List<String> ignore, java.io.PrintWriter out){
	  if(attrs == null) return;
	  Map<String,String> newattrs = new HashMap<String,String>();
	  filterAttributes(attrs, newattrs, selected);
	  handleAttrsAtHtmlElement(newattrs, classAttr, styleAttr, ignore, out);
  }
  
  public static void appendWithPadding(StringBuilder sb, String value){
	  if(value.length() > 0){
		  if(sb.length() > 0){
			  sb.append(" ");
		  }
		  sb.append(value);
	  }
  }		
  
  
  /*
   *  set or get dynamically selected attribute collections, part of template calls
   */
  
  public static void addDynamicSelectedAttributeCollection(Map<String,String> attrsout, String selected) {
	  attrsout.put("$AS$"+selected, "");
  }
  
  public static List<String> getDynamicSelectedAttributeCollections(Map<String,String> attrs) {
	  List<String> list = new ArrayList<String>();
	  if(attrs != null){
		  for(String key : attrs.keySet()){
			  if(key.startsWith("$AS$")){
				  list.add(key.substring(4));
			  }
		  }
	  }
	  return list;
  }


  
  /*
   *  set or get dynamically ignored attribute markers, part of template calls
   */
  
  public static void addDynamicIgnoredAttribute(Map<String,String> attrsout, String ignored) {
	  attrsout.put("$AI$"+ignored, "");
  }
  
  public static void getDynamicIgnoredAttributes(Map<String,String> attrs, List<String> ignorelist) {
	  if(attrs != null){
		  for(String key : attrs.keySet()){
			  if(key.startsWith("$AI$")){
				  ignorelist.add(key.substring(4));
			  }
		  }
	  }
  }
  

  /*
   *  attribute names to always ignore when selecting all attributes
   */

  public static boolean ignoredAttributeByDefault(String attr){
	  if(   attr.startsWith("$AI$") 
	     || attr.startsWith("$AS$")
	    // || attr.equals("class")
	     //|| attr.equals("style")
	     ){
		  return true;
	  }
	  return false;
  }
  
  
	public static final void printClassStyleAttributes(StringBuilder classattrs, StringBuilder styleattrs, java.io.PrintWriter out){
		if(classattrs.length() > 0){
			out.print(org.webdsl.tools.Utils.showAttributeEscapeHtml("class",classattrs));
		}
		if(styleattrs.length() > 0){
			out.print(org.webdsl.tools.Utils.showAttributeEscapeHtml("style",styleattrs)); 
		}
	}

}
