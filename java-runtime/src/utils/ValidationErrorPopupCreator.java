package utils;

public class ValidationErrorPopupCreator {
	
	public static String getErrorPopup( MultipleValidationExceptions mve ){
		if(mve == null)
			return "";
		
		StringBuilder sb = new StringBuilder( 1024 );
		sb.append("<script> alert('Error while loading this page due to the following validation error(s):\\n\\n");
		int cnt = 1;
		for (ValidationException ve : mve.getValidationExceptions()) {
			sb.append(cnt++).append(". ")
			  .append( org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(ve.getErrorMessage()) )
			  .append("\\n");
		}
		
		sb.append("');</script>");
		return sb.toString();
	}
}
