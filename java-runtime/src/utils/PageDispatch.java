package utils;

public class PageDispatch {
  public final Class<?> clazz;
  public final String[] args;
  public final Boolean[] entityArgs;
  public final boolean isAjaxTemplate;
  
  public PageDispatch(Class<?> c, String[] s, Boolean[] b, boolean ajax){
	  clazz = c;
	  args = s;
	  entityArgs = b;
	  isAjaxTemplate = ajax;
  }
  
  public Class<?> getPageClass(){return clazz;}
  public String[] getArgs(){return args;}
  public Boolean[] getEntityArgs(){return entityArgs;}
  public boolean isAjaxTemplate(){return isAjaxTemplate;}
}
