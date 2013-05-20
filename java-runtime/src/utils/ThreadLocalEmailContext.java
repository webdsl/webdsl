package utils;
public class ThreadLocalEmailContext {

    private static ThreadLocal<EmailServlet> emailServlet = new ThreadLocal<EmailServlet>();

    public static EmailServlet get() {
        return emailServlet.get();
    }
    
    public static void set(EmailServlet d) {
    	emailServlet.set(d);
    }
    
    public static boolean inEmailContext() {
    	return get() != null;
    }
}

