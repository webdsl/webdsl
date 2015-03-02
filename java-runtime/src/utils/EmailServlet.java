package utils;

import static utils.AbstractPageServlet.ACTION_PHASE;
import static utils.AbstractPageServlet.DATABIND_PHASE;
import static utils.AbstractPageServlet.RENDER_PHASE;
import static utils.AbstractPageServlet.VALIDATE_PHASE;

import java.io.IOException;
import java.util.Map;

import org.webdsl.lang.Environment;

public abstract class EmailServlet {

	public abstract void render(Object[] args, Environment env);
	protected void storeArguments(Object[] args){}
    protected void renderInternal(){}
    protected void initialize(){}
    protected void initActions(){}
    
	protected static java.util.Properties props = new java.util.Properties();
	protected static java.util.Properties sessionProps = new java.util.Properties();
	protected static String host = null;
	protected static String username = null;
	protected static String password = null;
	protected static String protocol = "smtps";
	protected static boolean authenticate = true;
	public AbstractPageServlet threadLocalPageCached = null;
	
    protected Environment env;
	
    protected String uniqueid;
    public String getUniqueId(){
    	if(uniqueid == null){
    		uniqueid = Encoders.encodeTemplateId(getTemplateClassName(), getTemplateContext(), threadLocalPageCached);
    	}
    	return uniqueid;
    }
    public abstract String getTemplateClassName();
    public String getTemplateContext(){
    	return threadLocalPageCached.getTemplateContextString();
    } 
	
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
			//            javax.mail.Session session = javax.mail.Session.getInstance(sessionProps, null);
		}
		catch(java.io.FileNotFoundException fnf) {
			org.webdsl.logging.Logger.error("File \"email.properties\" not found");
		}
		catch(IOException io) {
			org.webdsl.logging.Logger.error("IOException while reading \"email.properties\"");
		}
	}

	public String sender = "";
	public String receivers = "";
	public String cc = "";
	public String bcc = "";
	public String replyTo = "";
	public String subject = "";
	public String unsubscribeAddress = "";
	public java.io.StringWriter body = new java.io.StringWriter();

	public boolean send(){
		javax.mail.Session session = EmailServlet.getSession();
		javax.mail.internet.MimeMessage msg = new javax.mail.internet.MimeMessage(session);
		try{
			String htmlEncodingOption = "text/html; charset=UTF-8";
			String plainEncodingOption = "UTF-8";
			
			msg.setHeader( "Content-Type", htmlEncodingOption );

			msg.setRecipients(javax.mail.Message.RecipientType.TO,
					javax.mail.internet.InternetAddress.parse(this.receivers, false));
			msg.setRecipients(javax.mail.Message.RecipientType.CC,
					javax.mail.internet.InternetAddress.parse(this.cc, false));
			msg.setRecipients(javax.mail.Message.RecipientType.BCC,
					javax.mail.internet.InternetAddress.parse(this.bcc, false));
			
			if(this.unsubscribeAddress != null && !this.unsubscribeAddress.equals("")){
				msg.addHeader("List-Unsubscribe", "<" + this.unsubscribeAddress +">");
			}

			msg.setSubject(this.subject, plainEncodingOption);

			msg.setContent(body.toString(), htmlEncodingOption);

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
			return true;
		}
		catch(Exception e){
			org.webdsl.logging.Logger.error("exception in send email",e);
			return false;
		}
	}
	
	// similar to TemplateServlet.handleTemplateCall, but simplified because emails only have render phase
    protected void handleTemplateCall(int phase, boolean inForLoop, String forelementcounter, String tcallid, String tname, Object[] targs, Environment twithcallsmap, String parentname, Map<String,String> attrsmapout) throws InstantiationException, IllegalAccessException{
    	if(tcallid != null){
    		threadLocalPageCached.enterTemplateContext(tcallid);
    	}
		TemplateServlet calledInstance = (TemplateServlet) env.getTemplate(tname).newInstance();
		Environment newenv = twithcallsmap;
	    calledInstance.render(parentname, targs, newenv, attrsmapout);
    	if(tcallid != null){
    		threadLocalPageCached.leaveTemplateContext();
    	}
    	ThreadLocalTemplate.set(this);
    }
    
    public void printTemplateCallException(Exception ex, String errormessage){
    	org.webdsl.logging.Logger.error("Problem occurred while rendering email, in template call: "+errormessage);
    	utils.Warning.printSmallStackTrace(ex, 5);
    }

}
