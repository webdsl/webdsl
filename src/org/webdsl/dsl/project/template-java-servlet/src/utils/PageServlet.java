package utils;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;

public interface PageServlet {
    public void serve(HttpServletRequest request,
            HttpServletResponse response);
    
    public Session getHibSession();

    public HttpServletRequest getRequest() ;

    public HttpServletResponse getResponse();
    
    public void setValidated(boolean validated);
 
   // public HashMap<String, Class> getTemplates();
}
