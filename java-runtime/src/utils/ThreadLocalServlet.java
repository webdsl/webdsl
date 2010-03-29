package utils;
import javax.servlet.http.*;
public class ThreadLocalServlet {

    private static ThreadLocal dispatchServlet = new ThreadLocal();

    public static AbstractDispatchServletHelper get() {
        return (AbstractDispatchServletHelper) dispatchServlet.get();
    }
    
    public static void set(AbstractDispatchServletHelper d) {
        dispatchServlet.set(d);
    }
    
    public static String getContextPath(){
        return	get().getContextPath();
    }
    
}

