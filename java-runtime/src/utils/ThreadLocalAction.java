package utils;

import org.webdsl.lang.Environment;

public class ThreadLocalAction {

    private static ThreadLocal actionClass = new ThreadLocal();

    public static ActionClass get() {
        return (ActionClass) actionClass.get();
    }
    
    public static void set(ActionClass d) {
        actionClass.set(d);
    }   
    /*
    public static Environment getEnv() {
        ActionClass ac = get();
        if(ac != null){
          return ac.getEnv();
        }
        return null;
    }
    */
}
