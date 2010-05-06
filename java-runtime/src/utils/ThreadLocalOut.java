package utils;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
public class ThreadLocalOut {

    private static ThreadLocal outputWriter = new ThreadLocal();

    public static Stack<PrintWriter> get() {
        return (Stack<PrintWriter>) outputWriter.get();
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
            //throw new RuntimeException("wrong output PrintWriter popped");
        }
    }

}

