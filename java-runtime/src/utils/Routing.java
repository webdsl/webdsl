package utils;

import org.webdsl.logging.Logger;

public class Routing{
	static{
		Logger.info("routing customization used: no");
	}
	public static java.util.List<String> processRequest(java.util.List<String> args){
		return null;
	}
	public static java.util.List<String> processNavigate(String pagename, java.util.List<String> args){
		return null;
	}
}

// this class is meant to be overriden by WebDSL if custom routing is used,
// a generated class with the same name and package will take precedence in classloader over this library class