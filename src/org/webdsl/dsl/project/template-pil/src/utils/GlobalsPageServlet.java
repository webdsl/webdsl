package utils;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//dummy pageservlet instance for global init and global variables
//some expressions require this to be available, eg. property setters with extension events
public class GlobalsPageServlet extends PageServlet  
{ 
	public GlobalsPageServlet(HashMap<String,Object> vars){
		this.variablesGlobalAndSession = vars;
	}
	public void serve(HttpServletRequest request, HttpServletResponse response, Map<String, String> parammap, Map<String, List<String>> parammapvalues, Map<String, utils.File> fileUploads){}
	public String getPageName(){return "";}
	public String getHiddenParams(){return "";}
	public String getHiddenPostParams(){return "";}
}