package utils;

import org.webdsl.lang.Environment;

public class ThreadLocalTemplate {

    private static ThreadLocal<TemplateServlet> template = new ThreadLocal<TemplateServlet>();

    public static TemplateServlet get() {
        return template.get();
    }
    
    public static void set(TemplateServlet d) {
        template.set(d);
    	org.apache.log4j.MDC.put("template", d == null ? "null" : d.getTemplateSignature());
    } 
    
    //convenient for code generation, template call translation does a `ThreadLocalTemplate.set(this)` where `this` could be EmailServlet instead of TemplateServlet
    public static void set(EmailServlet d){
        setNull();
    } 
    
    public static void setNull(){
        template.set(null);
        org.apache.log4j.MDC.put("template", "null");
    }
    
    public static Environment getEnv() {
        TemplateServlet ts = get();
        if(ts != null){
          return ts.getEnv();
        }
        return null;
    }
}

