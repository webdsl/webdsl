package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletResponse;

public class ResponseWrapper{
	StringWriter s = new StringWriter();
	PrintWriter out = new PrintWriter(s);
	HttpServletResponse response;
	boolean outputStreamAccessed = false; 

	public ResponseWrapper(){}
	
	public ResponseWrapper(HttpServletResponse response){
		this.response = response;
	}

	public java.io.PrintWriter getWriter(){
		return out;
	}

	public void sendContent() throws IOException{
		if(!outputStreamAccessed){
			response.getWriter().write(s.toString());
		}
	}

	public void sendRedirect(String s) throws IOException{
		response.sendRedirect(s);
	}

	public void setContentType(String s){
		response.setContentType(s);
	}

	public javax.servlet.ServletOutputStream getOutputStream() throws IOException{
		outputStreamAccessed = true;
		return response.getOutputStream();
	}

	public void setHeader(String key, String value){
		response.setHeader(key, value);
	}
}
