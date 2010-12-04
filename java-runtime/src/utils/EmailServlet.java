package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.lang.Environment;

public abstract class EmailServlet {

    public abstract void render(Object[] args, Environment env);

    protected static java.util.Properties props = new java.util.Properties();
    protected static java.util.Properties sessionProps = new java.util.Properties();
    protected static String host = null;
    protected static String username = null;
    protected static String password = null;
    protected static String protocol = "smtps";
    protected static boolean authenticate = true;

    protected static javax.mail.Session getSession(){
        return javax.mail.Session.getInstance(sessionProps, null);
    }

    static {
        try {    
            props.load(EmailServlet.class.getResourceAsStream("/email.properties"));
            host = EmailServlet.props.getProperty("webdsl.email.host");
            String authprop = EmailServlet.props.getProperty("webdsl.email.authenticate"); 
            if(   "true".equals(authprop)
               ||"false".equals(authprop) ){
              authenticate = Boolean.valueOf(authprop);
            }
            if(authenticate){
              username = EmailServlet.props.getProperty("webdsl.email.user");
              password = EmailServlet.props.getProperty("webdsl.email.pass");
              sessionProps.put("mail.smtps.auth", "true");
            }
            String prot = EmailServlet.props.getProperty("webdsl.email.protocol");
            if("smtp".equals(prot) || "smtps".equals(prot)){
              protocol = prot;
            }
            sessionProps.put("mail.smtp.port", EmailServlet.props.getProperty("webdsl.email.port"));
            sessionProps.put("mail.smtps.port", EmailServlet.props.getProperty("webdsl.email.port"));
            javax.mail.Session session = javax.mail.Session.getInstance(sessionProps, null);
        }
        catch(java.io.FileNotFoundException fnf) {
            System.out.println("File \"email.properties\" not found");
        }
        catch(IOException io) {
            System.out.println("IOException while reading \"email.properties\"");   
        }
    }
    
    public String sender = "";
    public String receivers = "";
    public String cc = "";
    public String bcc = "";
    public String replyTo = "";
    public String subject = "";
    public java.io.StringWriter body = new java.io.StringWriter();
    
    public void send(){
        javax.mail.Session session = EmailServlet.getSession();
        
        javax.mail.internet.MimeMessage msg = new javax.mail.internet.MimeMessage(session);
   
        try{
            
            msg.setRecipients(javax.mail.Message.RecipientType.TO,
                    javax.mail.internet.InternetAddress.parse(this.receivers, false));
            msg.setRecipients(javax.mail.Message.RecipientType.CC,
                    javax.mail.internet.InternetAddress.parse(this.cc, false));
            msg.setRecipients(javax.mail.Message.RecipientType.BCC,
                    javax.mail.internet.InternetAddress.parse(this.bcc, false));

            msg.setSubject(this.subject);
      
            msg.setContent(body.toString(), "text/html");
            
            javax.mail.Address sender = javax.mail.internet.InternetAddress.parse(this.sender, false)[0];
            msg.setSender(sender);
            javax.mail.Address[] replyTo = javax.mail.internet.InternetAddress.parse(this.replyTo, false);
            msg.setReplyTo(replyTo);

            javax.mail.Transport transport = session.getTransport(protocol);
            try {
                transport.connect(host, username, password);
                transport.sendMessage(msg, msg.getAllRecipients());
            } finally {
                transport.close();
            }
        }
        catch(javax.mail.internet.AddressException ae){System.out.println(ae);}
        catch(javax.mail.MessagingException me){System.out.println(me);}
  }

}
