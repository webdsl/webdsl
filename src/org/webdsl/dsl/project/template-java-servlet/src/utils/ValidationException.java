package utils;
import java.util.*;

public class ValidationException extends RuntimeException {

	private String errorMessage;
	private List<Object> relevantObjects = new LinkedList<Object>();
	
	public ValidationException(String errorMessage){
		this.errorMessage = errorMessage;
	}
	
	public String getErrorMessage() {
		return errorMessage;
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
