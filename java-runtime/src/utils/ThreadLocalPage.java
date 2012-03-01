package utils;
import javax.servlet.http.*;
import org.webdsl.lang.Environment;

public class ThreadLocalPage {

    private static ThreadLocal page = new ThreadLocal();

    public static AbstractPageServlet get() {
        return (AbstractPageServlet) page.get();
    }
    
    public static void set(AbstractPageServlet d) {
        page.set(d);
    }
    public static Environment getEnv() {
        return get().envGlobalAndSession;
    }
}

