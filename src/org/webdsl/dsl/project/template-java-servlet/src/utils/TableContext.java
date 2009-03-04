package utils;

public class TableContext {
	
  public int inRowContext = 0;
  public int inColumnContext = 0;
  
  public boolean isInRowContext() {
    return inRowContext > 0;
  }
  public void enterRowContext() {
	  this.inRowContext++;
  }
  public void leaveRowContext() {
	  this.inRowContext--;
  }
  
  public boolean isInColumnContext() { 
    return inColumnContext > 0;
  }
  public void enterColumnContext() {
    this.inColumnContext++;
  }
  public void leaveColumnContext() {
	this.inColumnContext--;
  }
}
