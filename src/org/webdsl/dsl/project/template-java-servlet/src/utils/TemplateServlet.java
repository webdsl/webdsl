package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public interface TemplateServlet {
    public int handleActions(PageServlet ps,Object[] args,int templatecounter,HashMap<String, Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses);	
    
    public int storeInputs(PageServlet ps,Object[] args,int templatecounter,HashMap<String, Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses);
    
    public int render(PageServlet ps,Object[] args,int templatecounter,HashMap<String, Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses, java.io.PrintWriter out) ;
}
