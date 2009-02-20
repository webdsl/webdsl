package utils;
import java.util.*;

public class MultipleValidationExceptions extends RuntimeException {

	private List<ValidationException> validationExceptions = new LinkedList<ValidationException>();
	
	public MultipleValidationExceptions(java.util.List<ValidationException> ve){
		this.validationExceptions = ve;
	}

	public List<ValidationException> getValidationExceptions() {
		return validationExceptions;
	}

}
