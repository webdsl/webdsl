package utils;

import java.util.*;

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
  
  /*
   * just the value of the attribute, no escaping
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
   * whole attribute declaration, with escaping
   */
  
  public static String getAllAttributes(Map<String,String> attrs) {
      return getAllAttributesExcept(attrs,EmptyExceptList);
  }
  
  public static String getAllAttributesExcept(Map<String,String> attrs, String except) {
      List<String> list = new ArrayList();
      list.add(except);
      return getAllAttributesExcept(attrs,list);
  }
  public static String getAllAttributesExcept(Map<String,String> attrs, Collection<String> exceptlist) {
      if (attrs == null){ return ""; }
      else{
          StringBuilder sb = new StringBuilder();
          for(String key : attrs.keySet()){
              if(!exceptlist.contains(key)){
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
          StringBuilder sb = new StringBuilder();
          for(String key : selected){
              if(attrs.containsKey(key)){
                  sb.append(org.webdsl.tools.Utils.showAttributeEscapeHtml(key,attrs.get(key)));
              }   
          }
          return sb.toString();
      }
  }

  //this one should stay empty!!
  public static final Map<String, String> EmptyAttrs = new HashMap<String, String>();
  public static final List<String> EmptyExceptList = new ArrayList<String>();
  
}
