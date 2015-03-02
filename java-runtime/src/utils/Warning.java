package utils;

public class Warning {

    public static Object warn(String w){
        org.webdsl.logging.Logger.warn("WebDSL warning: "+w);
        return null;
    }

    public static void printSmallStackTrace(Exception e, int length){
    	StringBuilder sb = new StringBuilder(2048);
    	sb.append(e.getClass().getCanonicalName());
    	StackTraceElement[] stackTraceElements = e.getStackTrace();
    	for (int i = 0; i < Math.min(length, stackTraceElements.length); i++){
    		sb.append("\n");
    		sb.append("\tat ").append(stackTraceElementToString(i, stackTraceElements));
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
    		org.webdsl.logging.Logger.error(stackTraceElementToString(i, stackTraceElements));
    	}
    }

    public static String getStackTraceLineAtIndex(int index){
    	StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace();
    	StackTraceElement ste = stackTraceElements[index];
    	return ste.getClassName() + "." + ste.getMethodName() + ":" + ste.getLineNumber();
    }

    public static String stackTraceElementToString(int index, StackTraceElement[] stackTraceElements){
    	StackTraceElement ste = stackTraceElements[index];
    	String classname = ste.getClassName();
    	String methodName = ste.getMethodName();
    	int lineNumber = ste.getLineNumber();
    	return classname + "." + methodName + ":" + lineNumber;
    }

}
