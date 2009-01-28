package utils;
import java.util.*;

public class ValidationException extends RuntimeException {

	private String errorMessage;
	private List<Object> relevantObjects = new LinkedList<Object>();
	private String name = null; 
	
	public ValidationException(String name, String errorMessage){
		this.errorMessage = errorMessage;
		this.name = name;
	}
	
	public String getErrorMessage() {
		return errorMessage;
	}
	
	public String getName() {
		return name;
	}
	
	public List<Object> getRelevantObjects() {
		return relevantObjects;
	}
	
	public ValidationException addRelevantObject(Object o){
		relevantObjects.add(o);
		return this;
	}

	private static final long serialVersionUID = 8068783435980319210L;

}
