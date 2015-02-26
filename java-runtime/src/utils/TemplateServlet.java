package utils;

import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.HashMap;
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
    
    protected void storeInputsInternal(){}
    protected void validateInputsInternal(){}
    protected void handleActionsInternal(){}
    protected void renderInternal(){}

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
    public abstract String getTemplateClassName();
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
}
