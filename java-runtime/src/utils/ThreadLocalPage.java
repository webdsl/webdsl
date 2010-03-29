package utils;
import javax.servlet.http.*;
public class ThreadLocalPage {

    private static ThreadLocal page = new ThreadLocal();

    public static AbstractPageServlet get() {
        return (AbstractPageServlet) page.get();
    }
    
    public static void set(AbstractPageServlet d) {
        page.set(d);
    }    
}

