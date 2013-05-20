package utils;


public abstract class ActionClass {
    protected boolean validationDisabled = false;
    public boolean isValidationDisabled(){ return validationDisabled; }
    public void disableValidation(){ validationDisabled = true; }
    //public abstract Environment getEnv();
    
    protected boolean isRedirected = false;
    
    public void setIsRedirected(boolean b){
      isRedirected=b;
    }
}
