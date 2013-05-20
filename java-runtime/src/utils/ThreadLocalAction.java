package utils;


public class ThreadLocalAction {

    private static ThreadLocal<ActionClass> actionClass = new ThreadLocal<ActionClass>();

    public static ActionClass get() {
        return actionClass.get();
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
