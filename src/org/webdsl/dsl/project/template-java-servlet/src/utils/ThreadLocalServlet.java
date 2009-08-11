package utils;
import javax.servlet.http.*;
public class ThreadLocalServlet {

    private static ThreadLocal dispatchServlet = new ThreadLocal();

    public static HttpServlet get() {
        return (HttpServlet) dispatchServlet.get();
    }
    
    public static void set(HttpServlet d) {
    	dispatchServlet.set(d);
    }
    
    public static String getContextPath(){
    	return	get().getServletConfig().getServletContext().getContextPath();
    }
    
}

