package utils;

public abstract class ActionClass {
    public abstract void setIsRedirected(boolean b);
    protected boolean validationDisabled = false;
    public boolean isValidationDisabled(){ return validationDisabled; }
    public void disableValidation(){ validationDisabled = true; }
}
