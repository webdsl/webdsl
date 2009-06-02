package utils;

public class TemplateCall {
	
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
	
  public boolean valid;
  public String name;
  public Object[] args;
  
}
