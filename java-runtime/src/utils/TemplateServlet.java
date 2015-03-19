package utils;

import static utils.AbstractPageServlet.DATABIND_PHASE;
import static utils.AbstractPageServlet.VALIDATE_PHASE;
import static utils.AbstractPageServlet.ACTION_PHASE;
import static utils.AbstractPageServlet.RENDER_PHASE;

import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.lang.Environment;

public abstract class TemplateServlet {
    
    public static TemplateServlet getCurrentTemplate(){
        return ThreadLocalTemplate.get();
    }
    
    protected boolean validated=true;
    protected String uniqueid;
    public String getUniqueId(){
      if(uniqueIdOverride.isEmpty()){
    	if(uniqueid == null){
    		uniqueid = Encoders.encodeTemplateId(getTemplateClassName(), getTemplateContext(), threadLocalPageCached);
    	}
        return uniqueid;
      }
      else{
        return uniqueIdOverride.peek();
      }
    }
    public void pushUniqueIdOverride(String s){
        uniqueIdOverride.push(s);
    }
    public void popUniqueIdOverride(){
        uniqueIdOverride.pop();
    }
    protected ArrayDeque<String> uniqueIdOverride = new ArrayDeque<String>(); 
    protected Environment env;
    public Environment getEnv(){
        return env;
    }
    private java.util.Map<String, Object> templatecalls = null;
    protected java.util.Map<String, Object> getTemplatecalls(){
      if(templatecalls == null){
        templatecalls = new java.util.HashMap<String, Object>();
      }
      return templatecalls;
    }
    protected boolean onlyPerformingRenderPhase(){
        return templatecalls == null;
    }
    protected org.hibernate.Session hibSession;
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected boolean initialized = false;
    protected utils.TemplateCall templateArg;
    protected Map<String,String> attrs = null;
    protected String[] pageArguments = null;
    public void setPageArguments(String[] pa){
    	pageArguments = pa;
    }
    public String[] getPageArguments(){
    	return pageArguments;
    }
    
    // cancels further handling of this template, e.g. when validation error occurs in init
    protected boolean skipThisTemplate = false;
    
    protected boolean initializeLocalVarsOnceExecuted = false;
    protected void tryInitializeVarsOnce(){
      if(!initializeLocalVarsOnceExecuted){
        initializeLocalVarsOnceExecuted = true;  
        initializeLocalVarsOnce();
      }
    }
    
    public void prefetchFor(int i, java.util.Collection<? extends org.webdsl.WebDSLEntity> elems){}
    
    public void storeInputs(String calledName, Object[] args, Environment env, Map<String,String> attrs) {
        if(!skipThisTemplate){
          tryInitializeTemplate(calledName, args, env, attrs);
          tryInitializeVarsOnce(); //this phase could be skipped, so performed in render as well
          storeInputsInternal();
        }
      }  
    public void validateInputs(String calledName, Object[] args, Environment env,  Map<String,String> attrs) {
        if(!skipThisTemplate){
          tryInitializeTemplate(calledName, args, env, attrs);
          validateInputsInternal();
        }
      } 
    public void handleActions(String calledName, Object[] args, Environment env, Map<String,String> attrs) {          
        if(!skipThisTemplate){
          tryInitializeTemplate(calledName, args, env, attrs);
          handleActionsInternal();
        }
      }  

    public void render(String calledName, Object[] args, Environment env, Map<String,String> attrs) { 
      if(!skipThisTemplate){
        tryInitializeTemplate(calledName, args, env, attrs);
        tryInitializeVarsOnce();
     
        java.io.StringWriter s = new java.io.StringWriter();

        PrintWriter out = new java.io.PrintWriter(s);
        ThreadLocalOut.push(out);
        beforeRender();
        renderInternal();
        afterRender();
        ThreadLocalOut.popChecked(out);
        out = ThreadLocalOut.peek();
        
        tryWriteSpanOpen(out);
        out.write(s.toString());
        tryWriteSpanClose(out);
      }
    }
    
    protected void storeInputsInternal(){
    	handlePhase(DATABIND_PHASE);
    }
    protected void validateInputsInternal(){
    	handlePhase(VALIDATE_PHASE);
    }
    protected void handleActionsInternal(){
    	handlePhase(ACTION_PHASE);
    }
    protected void renderInternal(){
    	handlePhase(RENDER_PHASE);
    }
    protected abstract void handlePhase(int phase);

    protected boolean isAjaxTemplate(){ 
    	return false;
    }

    private boolean alreadyPassedThroughAjaxTemplate = false;
    protected void beforeRender(){
        if(threadLocalPageCached.passedThroughAjaxTemplate()){
            alreadyPassedThroughAjaxTemplate = true;
        }
        else if(isAjaxTemplate()){
        	threadLocalPageCached.setPassedThroughAjaxTemplate(true);
        }
    }
    protected void afterRender(){
        if(!alreadyPassedThroughAjaxTemplate && isAjaxTemplate()){
        	threadLocalPageCached.setPassedThroughAjaxTemplate(false);
        }    	
    }
    
    protected void tryWriteSpanOpen(PrintWriter outtemp){}
    protected void tryWriteSpanClose(PrintWriter outtemp){}
    protected void putLocalDefinesInEnv(){}
    protected void storeArguments(Object[] args){}
    
    protected void initialize(){}
    protected void initSubmitActions(){}
    protected void initActions(){}
    protected void initializeLocalVars(){}
    protected void initializeLocalVarsOnce(){}
    
    public abstract String getUniqueName();
    public String getTemplateClassName(){ 
    	return getUniqueName() + "_Template";
    }
    public abstract String getTemplateSignature();
    public abstract String getStateEncodingOfArgument();
    public String getTemplateContext(){
      return threadLocalPageCached.getTemplateContextString();
    } 
    
    //template name used to call it might be different due to override/local redefine
    //null means use the regular unique template name
    protected String calledName;
    
    public AbstractPageServlet threadLocalPageCached = null;
    
    private void tryInitializeTemplate(String calledName, Object[] args, Environment env, Map<String,String> attrs){
        //always set ThreadLocalTemplate
        ThreadLocalTemplate.set(this);
        
        //cache ThreadLocalPage.get() lookup
        threadLocalPageCached = ThreadLocalPage.get();
        
        //always store env and arguments, values might change between phases
        // We ensure that there is an env, because prefetching in storeArguments() may use env.getTemplate()
        this.env = env;
        storeArguments(args);
        // storing local define arguments inputLocalDefinesInEnv() could use template arguments, so needs to come after storeArguments(args)
        putLocalDefinesInEnv();
        
        if(!initialized || threadLocalPageCached.hibernateCacheCleared)
        {
              //System.out.println("template init "+"~x_Page"+"init: "+initialized+ " hibcache: "+ThreadLocalPage.get().hibernateCacheCleared);
              initialized=true;
              
              this.calledName = calledName;
              this.request = threadLocalPageCached.getRequest();
              this.response = threadLocalPageCached.getResponse();
              //if(request != null){ //calling rendertemplate within background task
              //  this.session = request.getSession(true);
              //}
              this.hibSession = threadLocalPageCached.hibernateSession;
              this.attrs = attrs;
              try {
                initialize();
                initializeLocalVars();
                initSubmitActions();
                initActions();
              }
              catch(utils.ValidationException ve){
            	threadLocalPageCached.getValidationExceptions().add(ve.setName(threadLocalPageCached.getValidationContext()));
            	threadLocalPageCached.setValidated(false);
                utils.Warning.warn("Validation failed in initialization of "+getTemplateSignature()+": "+ve.getErrorMessage());  
            skipThisTemplate = true;
          }
          catch(utils.MultipleValidationExceptions ve){
            for(utils.ValidationException vex : ve.getValidationExceptions()){
              threadLocalPageCached.getValidationExceptions().add(vex.setName(threadLocalPageCached.getValidationContext()));
              utils.Warning.warn("Validation failed in initialization of "+getTemplateSignature()+": "+vex.getErrorMessage());  
            }
            threadLocalPageCached.setValidated(false); 
            skipThisTemplate = true;
          }
        } 
    } 
    
    
    protected boolean isAjaxSubmitRequired(){
        return isAjaxSubmitRequired(false);
    }
    
    protected boolean isAjaxSubmitRequired(boolean ajaxmod){
      return threadLocalPageCached.isServingAsAjaxResponse //template is rendered in an action, e.g. with replace(placeholder,templatecall())
        || threadLocalPageCached.isAjaxRuntimeRequest() //current request came from ajax runtime
        || threadLocalPageCached.passedThroughAjaxTemplate() // passed through template defined with ajax modifier 'define ajax'
        || ajaxmod //submit buttons is defined with ajax modifier '[ajax]'
        || threadLocalPageCached.getFormIdent().equals(""); //submit is not in a form (normal browser submit won't work)
    }
    
    
    protected void handleTemplateCall(int phase, boolean inForLoop, String forelementcounter, TemplateContext tcallid, String tname, Object[] targs, Environment twithcallsmap, String parentname, Map<String,String> attrsmapout){
    	utils.TemplateContext tmptc = threadLocalPageCached.getTemplateContext();
    	threadLocalPageCached.setTemplateContext(tcallid); 
    	handleTemplateCall(phase, inForLoop, forelementcounter, (String)null, tname, targs, twithcallsmap, parentname, attrsmapout);
    	threadLocalPageCached.setTemplateContext(tmptc);
    }

    protected void handleTemplateCall(int phase, boolean inForLoop, String forelementcounter, String tcallid, String tname, Object[] targs, Environment twithcallsmap, String parentname, Map<String,String> attrsmapout){
    	String ident = "";
    	if(inForLoop){ 
    		ident += forelementcounter;
    	}
    	if(tcallid != null){
    		threadLocalPageCached.enterTemplateContext(tcallid);
    		ident += tcallid;    		
    	}
    	else{
    		ident += "customtc";
    	}
    	TemplateServlet calledInstance = null;
    	try{
    		if(RENDER_PHASE == phase && onlyPerformingRenderPhase()){
    			calledInstance = (TemplateServlet) env.getTemplate(tname).newInstance();
    		}
    		else{
    			calledInstance = (TemplateServlet) getTemplatecalls().get(ident);
    			if(calledInstance == null){
    				calledInstance = (TemplateServlet) env.getTemplate(tname).newInstance();
    				getTemplatecalls().put(ident, calledInstance);
    			}
    		}
    	} 
    	catch (InstantiationException e){
    		e.printStackTrace();
    	} 
    	catch (IllegalAccessException e){
    		e.printStackTrace();
    	}
		Environment newenv = twithcallsmap;
		// this includes passing the called name, so that the called template can figure out what name was used to call it, might be different due to override/local redefine
	    switch(phase){
          case DATABIND_PHASE: calledInstance.storeInputs(parentname, targs, newenv, attrsmapout); break;
          case VALIDATE_PHASE: calledInstance.validateInputs(parentname, targs, newenv, attrsmapout); break;
          case ACTION_PHASE:   calledInstance.handleActions(parentname, targs, newenv, attrsmapout); break;
          case RENDER_PHASE:   calledInstance.render(parentname, targs, newenv, attrsmapout); break;
        }
    	if(tcallid != null){
    		threadLocalPageCached.leaveTemplateContextChecked(tcallid);
    	}
    	ThreadLocalTemplate.set(this);
    }
 
    public void printTemplateCallException(RuntimeException ex, String errormessage){
    	if(ex instanceof NullPointerException || ex instanceof IndexOutOfBoundsException){  // ignore the template for these cases
    	  	org.webdsl.logging.Logger.error("Problem occurred in template call: "+errormessage);
        	utils.Warning.printSmallStackTrace(ex, 5);  // print first few lines of stack trace to indicate location, should be removed when location is always available for original webdsl line of code
    	}
    	else{
    		throw ex;
    	}
    }

    public String debugStateEncodingAll(){ 
    	return "TemplateClass: " + getTemplateClassName() + "\nTemplateArgument: " + getStateEncodingOfArgument() + "\nContextString: " + getTemplateContext() + "\nUniqueId: " + getUniqueId();
    }
}
