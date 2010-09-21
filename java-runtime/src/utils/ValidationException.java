package utils;
import java.util.*;

public class ValidationException extends RuntimeException {

    private String errorMessage;
    private List<Object> relevantObjects = new LinkedList<Object>();
    private String name = null; 
    
    public ValidationException(String name, String errorMessage){
        this.name = name;
        this.errorMessage = errorMessage;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public String getName() {
        return name;
    }
    
    public ValidationException setName(String name) {
        this.name=name;
        return this;
    }	
    
    public List<Object> getRelevantObjects() {
        return relevantObjects;
    }
    
    public ValidationException addRelevantObject(Object o){
        relevantObjects.add(o);
        return this;
    }
    
    //not interested in equals here, should be the exact same instance
    public boolean isRelevantObject(Object o){
        for(Object ob : relevantObjects){
            if(ob==o){
                return true;
            }
        }
        return false;
    }

    private static final long serialVersionUID = 8068783435980319210L;

}
