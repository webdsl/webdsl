package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.lang.Environment;


public interface TemplateServlet {
    
    public void storeInputs(Object[] args, Environment env, utils.TemplateCall templateArg, Map<String, utils.TemplateCall> withcallsmap, Map<String,String> attrs);

    public void validateInputs(Object[] args, Environment env, utils.TemplateCall templateArg, Map<String, utils.TemplateCall> withcallsmap, Map<String,String> attrs);

    public void handleActions(Object[] args, Environment env, utils.TemplateCall templateArg, Map<String, utils.TemplateCall> withcallsmap, Map<String,String> attrs, java.io.PrintWriter out);	
    
    public void render(Object[] args, Environment env, utils.TemplateCall templateArg, Map<String, utils.TemplateCall> withcallsmap, Map<String,String> attrs, java.io.PrintWriter out) ;
    
    public String getUniqueName();
}
