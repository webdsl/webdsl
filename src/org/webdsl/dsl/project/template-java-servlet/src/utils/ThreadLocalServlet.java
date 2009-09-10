package utils;
import javax.servlet.http.*;
public class ThreadLocalServlet {

    private static ThreadLocal dispatchServlet = new ThreadLocal();

    public static DispatchServletHelper get() {
        return (DispatchServletHelper) dispatchServlet.get();
    }
    
    public static void set(DispatchServletHelper d) {
        dispatchServlet.set(d);
    }
    
    public static String getContextPath(){
        return	get().getContextPath();
    }
    
}

