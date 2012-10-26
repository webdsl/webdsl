package utils;

public class Warning {

    public static Object warn(String w){
        org.webdsl.logging.Logger.warn("WebDSL warning: "+w);
        return null;
    }

    public static void printSmallStackTrace(Exception e){
        StringBuffer sb = new StringBuffer();
        sb.append(e.getClass().getCanonicalName());
        sb.append("\n");
        sb.append(e.getLocalizedMessage());
        StackTraceElement[] stack = e.getStackTrace();
        if(stack.length > 0){
            sb.append("\n");
            sb.append("\tat "+stack[0].toString());
        }
        org.webdsl.logging.Logger.error(sb.toString());
    }

}
