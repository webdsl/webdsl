package utils;

public interface RefArg
{ 
  public Object set(Object obj);
  public Object get();
  //used for page ref arg and ajax template ref arg
  public void load(String uuid);
  public String getUrlString();
  public String get_WebDslEntityType();
  public org.webdsl.WebDSLEntity getEntity();
  public void validate(String location, java.util.List<utils.ValidationException> exceptions);
  public java.util.List<String> getValidationErrors();
}