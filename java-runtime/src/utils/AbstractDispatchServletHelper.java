package utils;

import javax.servlet.http.HttpServletRequest;

public abstract class AbstractDispatchServletHelper{
  public abstract String getContextPath();
  public abstract String getRequestedPage();
  public boolean isPostRequest;
  public abstract HttpServletRequest getRequest();
  public abstract java.util.HashMap<String, utils.PageDispatch> getPages();
  public abstract int getHttpsPort();
  public abstract int getHttpPort();
}