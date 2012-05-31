package utils;

public class URLTrimmer {

    public static String removeTrailingDefaultValues(String s, String... strings){
        String[] parts = s.split("/");

        //remove trailing default values
        int i = 0;
        for(i = parts.length - 1; i >= 0; i--){
            if( !(parts[i].equals("") && utils.TypesInfo.getStringCompatibleTypes().contains(strings[i]))
                    && !(parts[i].equals("0") && strings[i].equals("Int"))
                    && !(parts[i].equals("0.0") && strings[i].equals("Float"))
            ){
                break;
            }
        }

        //make one string for URL
        StringBuffer sb = new StringBuffer();
        for(int j = 0; j <= i; j++){
            sb.append("/");
            sb.append(parts[j]);
        }
        return sb.toString();
    }

}
