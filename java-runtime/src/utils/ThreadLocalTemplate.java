package utils;

public class ThreadLocalTemplate {

    private static ThreadLocal<TemplateServlet> template = new ThreadLocal<TemplateServlet>();

    public static TemplateServlet get() {
        return template.get();
    }
    
    public static void set(TemplateServlet d) {
        template.set(d);
    }    
}

