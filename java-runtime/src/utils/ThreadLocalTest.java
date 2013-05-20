package utils;
public class ThreadLocalTest {

    private static ThreadLocal<Test> test = new ThreadLocal<Test>();

    public static Test get() {
        return test.get();
    }
    
    public static void set(Test t) {
        test.set(t);
    }    
}

