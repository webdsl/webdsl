package webdsl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public abstract class TemplateServlet {
    public abstract int handleActions(utils.PageServlet ps,Object[] args,int templatecounter,HashMap<String, pil.reflect.Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses, webdsl.util.StringWriter out);	
    
    public abstract int storeInputs(utils.PageServlet ps,Object[] args,int templatecounter,HashMap<String, pil.reflect.Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses);
    
    public abstract int render(utils.PageServlet ps,Object[] args,int templatecounter,HashMap<String, pil.reflect.Class> templates,HashMap<String, Object> variables,HashMap<String, Object> actionclasses, webdsl.util.StringWriter out) ;
}
