package utils;

public class Warning {

    public static Object warn(String w){
        System.out.println("WebDSL warning: "+w);
        return null;
    }
    
    public static void printSmallStackTrace(Exception e){
        System.out.println(e.getClass().getCanonicalName());
        System.out.println(e.getLocalizedMessage());
        StackTraceElement[] stack = e.getStackTrace();
        if(stack.length > 0){
            System.out.println("\tat "+stack[0].toString());
        }
    }
    
}
