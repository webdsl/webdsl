package utils;
import java.io.PrintWriter;
import java.util.Stack;

public class ThreadLocalOut {

    private static ThreadLocal<Stack<PrintWriter>> outputWriter = new ThreadLocal<Stack<PrintWriter>>();

    public static Stack<PrintWriter> get() {
        return outputWriter.get();
    }

    public static void set(Stack<PrintWriter> d) {
        outputWriter.set(d);
    }

    public static PrintWriter peek(){
        return get().peek();
    }

    public static void push(PrintWriter pw){
        Stack<PrintWriter> s = get();
        if(s == null){
            set(new Stack<PrintWriter>());
        }
        get().push(pw);
    }

    public static PrintWriter pop(){
        return get().pop();
    }

    public static void popChecked(PrintWriter pw){
        if(pw != pop()){
            Warning.warn("wrong output PrintWriter popped");
            Warning.printSmallStackTrace(1,1);
        }
    }

}

