package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public abstract class EmailServlet {

    public abstract void render(PageServlet ps, Object[] args, HashMap<String, Object> variables, java.io.PrintWriter out);
    
    public static java.util.Properties props = new java.util.Properties();
    
    static {
      try {    
        props.load(EmailServlet.class.getResourceAsStream("/email.properties")) ;
      }
      catch(java.io.FileNotFoundException fnf) {
        System.out.println("File \"email.properties\" not found");
      }
      catch(IOException io) {
        System.out.println("IOException while reading \"email.properties\"");   
      }
    }

}
