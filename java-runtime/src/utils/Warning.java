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

    public static void printSmallStackTrace(int length){
    	printSmallStackTrace(length,0);
    }
    public static void printSmallStackTrace(int length, int offset){
        StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace();
        offset = offset + 2; // start at 2 to skip getStackTrace and this function itself
        for (int i=offset ; i<Math.min(offset+length, stackTraceElements.length); i++)
        {
         StackTraceElement ste = stackTraceElements[i];
         String classname = ste.getClassName();
         String methodName = ste.getMethodName();
         int lineNumber = ste.getLineNumber();
         System.out.println( classname+"."+methodName+":"+lineNumber);
        }
   }

}
