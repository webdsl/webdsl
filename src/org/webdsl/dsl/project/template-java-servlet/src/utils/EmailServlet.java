package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.lang.Environment;

public abstract class EmailServlet {

	public abstract void render(PageServlet ps, Object[] args, Environment env, java.io.PrintWriter out);

	protected static java.util.Properties props = new java.util.Properties();
	protected static java.util.Properties sessionProps = new java.util.Properties();
	protected static String host;
	protected static String username;
	protected static String password;

	protected static javax.mail.Session getSession(){
		return javax.mail.Session.getInstance(sessionProps, null);
	}

	static {
		try {    
			props.load(EmailServlet.class.getResourceAsStream("/email.properties"));
			host     = EmailServlet.props.getProperty("webdsl.email.host");
			username = EmailServlet.props.getProperty("webdsl.email.user");
			password = EmailServlet.props.getProperty("webdsl.email.pass");
			sessionProps.put("mail.smtps.auth", "true");
			sessionProps.put("mail.smtps.port", EmailServlet.props.getProperty("webdsl.email.port"));
			javax.mail.Session session = javax.mail.Session.getInstance(sessionProps, null);
			//TODO set SSL/TLS	
		}
		catch(java.io.FileNotFoundException fnf) {
			System.out.println("File \"email.properties\" not found");
		}
		catch(IOException io) {
			System.out.println("IOException while reading \"email.properties\"");   
		}
	}

}
