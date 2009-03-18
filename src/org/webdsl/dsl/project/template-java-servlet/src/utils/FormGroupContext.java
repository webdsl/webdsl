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
  
  public int inDoubleColumnContext = 0;
  
  public boolean isInDoubleColumnContext() {
    return inDoubleColumnContext > 0;
  }
  public void enterDoubleColumnContext() {
	  toLeftContext();  // after this start left
	  this.inDoubleColumnContext++;
  }
  public void leaveDoubleColumnContext() {
	  this.inDoubleColumnContext--;
  }
}
