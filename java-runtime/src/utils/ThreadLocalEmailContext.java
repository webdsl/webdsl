package utils;
import javax.servlet.http.*;
public class ThreadLocalEmailContext {

    private static ThreadLocal emailServlet = new ThreadLocal();

    public static EmailServlet get() {
        return (EmailServlet) emailServlet.get();
    }
    
    public static void set(EmailServlet d) {
    	emailServlet.set(d);
    }
    
    public static boolean inEmailContext() {
    	return get() != null;
    }
}

