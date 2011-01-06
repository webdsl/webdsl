package utils;

public class EmailType {
    
    /*
    The local-part of the e-mail address may use any of these ASCII characters:
      - Uppercase and lowercase English letters (a-z, A-Z)
      - Digits 0 to 9
      - Characters ! # $ % & ' * + - / = ? ^ _ ` { | } ~
      - Character . (dot, period, full stop) provided that it is not the first or last character, and provided also that it does not appear two or more times consecutively.
    */
    public static Boolean isValid(String s){
      if(s != null && s.equals("") || s.matches("^([a-zA-Z0-9!#$%&'*\\+\\-/=\\?\\^_`{|}~\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)")) {
        return true;
      }
      return false;
    }
    
}
