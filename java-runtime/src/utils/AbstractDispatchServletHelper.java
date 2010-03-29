package utils;

public abstract class AbstractDispatchServletHelper{
  public abstract String getContextPath();
  public abstract String getRequestedPage();
  public boolean isPostRequest;
}