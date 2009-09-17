package utils;

public class ThreadLocalAction {

    private static ThreadLocal actionClass = new ThreadLocal();

    public static ActionClass get() {
        return (ActionClass) actionClass.get();
    }
    
    public static void set(ActionClass d) {
    	actionClass.set(d);
    }   
}

