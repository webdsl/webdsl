package utils;

public class URLType {
    
	
	/*	
		tests: @ https://regex101.com/r/pH6cY5/1
		inspired by https://mathiasbynens.be/demo/url-regex and the pattern from @imme_emosol
		
		Accepts any protocol (required)
	*/
    public static Boolean isValid(String s){
      if(s != null && s.equals("") || s.matches("^([a-zA-Z]+):\\/\\/(-\\.)?(([^\\s\\/?\\.#\\-]+|([^\\s\\/?\\.#\\-]-[^\\s\\/?\\.#\\-]))\\.?)+(\\/[^\\s]*)?$")) {
        return true;
      }
      return false;
    }   
}
