package utils;
public class ThreadLocalTest {

    private static ThreadLocal test = new ThreadLocal();

    public static Test get() {
        return (Test) test.get();
    }
    
    public static void set(Test t) {
        test.set(t);
    }    
}

