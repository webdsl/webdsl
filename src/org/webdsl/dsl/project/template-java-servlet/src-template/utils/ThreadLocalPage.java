package utils;
import javax.servlet.http.*;
public class ThreadLocalPage {

    private static ThreadLocal page = new ThreadLocal();

    public static PageServlet get() {
        return (PageServlet) page.get();
    }
    
    public static void set(PageServlet d) {
        page.set(d);
    }    
}

