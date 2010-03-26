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
  
  public int inColumnContext = 0;
  
  public boolean isInColumnContext() {
	  return inColumnContext > 0;
  }
  public void enterColumnContext() {
	  toLeftContext();  // after this start left
	  this.inColumnContext++;
  }
  public void leaveColumnContext() {
	  this.inColumnContext--;
  }
}
