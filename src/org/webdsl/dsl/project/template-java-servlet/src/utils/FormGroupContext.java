package utils;

public class FormGroupContext {
	
  public boolean inLeftContext = true;

  public boolean isInLeftContext(){
	  return inLeftContext;
  }
  
  public void toLeftContext() {
	  inLeftContext = true;
  }

  public void toRightContext() {
	  inLeftContext = false;
  }
}
