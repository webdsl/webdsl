package utils;
public class ThreadLocalServlet {

    private static ThreadLocal<AbstractDispatchServletHelper> dispatchServlet = new ThreadLocal<AbstractDispatchServletHelper>();

    public static AbstractDispatchServletHelper get() {
        return dispatchServlet.get();
    }
    
    public static void set(AbstractDispatchServletHelper d) {
        dispatchServlet.set(d);
    }
    
    public static String getContextPath(){
        return	get().getContextPath();
    }
    
}

