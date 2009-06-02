package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.lang.Environment;


public interface TemplateServlet {
    
    public int storeInputs(PageServlet ps,Object[] args, int templatecounter, Environment env, utils.TemplateCall templateArg);

    public int validateInputs(PageServlet ps,Object[] args, int templatecounter, Environment env, utils.TemplateCall templateArg);

	public int handleActions(PageServlet ps,Object[] args, int templatecounter, Environment env, utils.TemplateCall templateArg, java.io.PrintWriter out);	
    
    public int render(PageServlet ps,Object[] args, int templatecounter, Environment env, utils.TemplateCall templateArg, java.io.PrintWriter out) ;
}
