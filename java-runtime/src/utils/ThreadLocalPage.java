package utils;
import org.webdsl.lang.Environment;

public class ThreadLocalPage {

    private static ThreadLocal<AbstractPageServlet> page = new ThreadLocal<AbstractPageServlet>();

    public static AbstractPageServlet get() {
        return page.get();
    }

    public static void set(AbstractPageServlet d) {
        page.set(d);
    }
    public static Environment getEnv() {
        return get().envGlobalAndSession;
    }
    public static boolean isReadOnly(){
    	AbstractPageServlet p = get();
    	if(p != null){
    		return p.isReadOnly;
    	}
    	return false;
    }
}

