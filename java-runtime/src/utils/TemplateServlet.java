package utils;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.webdsl.lang.Environment;

public abstract class TemplateServlet {
    
    protected boolean validated=true;
    protected String uniqueid;
    protected Environment env;
    protected java.util.Map<String, Object> templatecalls = new java.util.HashMap<String, Object>();
    protected org.hibernate.Session hibSession;
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected boolean initialized = false;
    protected utils.TemplateCall templateArg;
    protected Map<String,String> attrs = null;
    protected String[] pageArguments = null;
    protected HttpSession session;
    protected utils.LocalTemplateArguments ltas;
    // cancels further handling of this template, e.g. when validation error occurs in init
    protected boolean skipThisTemplate = false;
    
    protected boolean initializeLocalVarsOnceExecuted = false;
    protected void tryInitializeVarsOnce(){
      if(!initializeLocalVarsOnceExecuted){
        initializeLocalVarsOnceExecuted = true;  
        initializeLocalVarsOnce();
      }
    }
    
    public void storeInputs(Object[] args, Environment env, Map<String,String> attrs, utils.LocalTemplateArguments ltas) {
        if(!skipThisTemplate){
          tryInitializeTemplate(args, env, attrs, ltas);
          tryInitializeVarsOnce(); //this phase could be skipped, so performed in render as well
          storeInputsInternal();
        }
      }  
    public void validateInputs(Object[] args, Environment env,  Map<String,String> attrs, utils.LocalTemplateArguments ltas) {
        if(!skipThisTemplate){
          tryInitializeTemplate(args, env, attrs, ltas);
          validateInputsInternal();
        }
      } 
    public void handleActions(Object[] args, Environment env, Map<String,String> attrs, utils.LocalTemplateArguments ltas) {          
        if(!skipThisTemplate){
          tryInitializeTemplate(args, env, attrs, ltas);
          handleActionsInternal();
        }
      }  

    public void render(Object[] args, Environment env, Map<String,String> attrs, utils.LocalTemplateArguments ltas) { 
      if(!skipThisTemplate){
        tryInitializeTemplate(args, env, attrs, ltas);
        tryInitializeVarsOnce();
     
        java.io.StringWriter s = new java.io.StringWriter();

        PrintWriter out = new java.io.PrintWriter(s);
        ThreadLocalOut.push(out);
        renderInternal();
        ThreadLocalOut.popChecked(out);
        out = ThreadLocalOut.peek();
        
        tryWriteSpanOpen(out);
        out.write(s.toString());
        tryWriteSpanClose(out);
      }
    }
    
    protected abstract void storeInputsInternal();
    protected abstract void validateInputsInternal();
    protected abstract void handleActionsInternal();
    protected abstract void renderInternal();
    
    protected abstract void tryWriteSpanOpen(PrintWriter outtemp);
    protected abstract void tryWriteSpanClose(PrintWriter outtemp);
    protected abstract void putLocalDefinesInEnv();
    protected abstract void storeArguments(Object[] args);
    
    protected abstract void initialize();
    protected abstract void initSubmitActions();
    protected abstract void initActions();
    protected abstract void initializeLocalVars();
    protected abstract void initializeLocalVarsOnce();
    
    public abstract String getUniqueName();
    public abstract String getTemplateClassName();
    public abstract String getTemplateSignature();
    public abstract String getStateEncodingOfArgument();
    public abstract String getTemplateContext();
    
    private Map<String,Object> actions = null;
    public Map<String,Object> getActions(){
        return actions;
    }
    public Object getAction(String key) {
        if (actions != null && actions.containsKey(key)){
            return actions.get(key);
        }
        else{
            throw new RuntimeException("Action with name "+key+" was not found in template "+getUniqueName());
        }
    }
    public void putAction(String key, Object value) {
        if(actions == null){
            actions = new HashMap<String,Object>();
        }
        actions.put(key, value);
    }
    
    private void tryInitializeTemplate(Object[] args, Environment env, Map<String,String> attrs, utils.LocalTemplateArguments ltas){
        //always set ThreadLocalTemplate
        ThreadLocalTemplate.set(this);
        
        if(!initialized || ThreadLocalPage.get().hibernateCacheCleared)
        {
              //System.out.println("template init "+"~x_Page"+"init: "+initialized+ " hibcache: "+ThreadLocalPage.get().hibernateCacheCleared);
              initialized=true;
              
              this.env = env;
              putLocalDefinesInEnv();
              this.request = ThreadLocalPage.get().getRequest();
              this.response = ThreadLocalPage.get().getResponse();
              if(request != null){ //calling rendertemplate within background task
                this.session = request.getSession(true);
              }
              this.hibSession = ThreadLocalPage.get().getHibSession();
              this.attrs = attrs;
              this.ltas = ltas;
              try {
                storeArguments(args);
                this.uniqueid = Encoders.encodeTemplateId(getTemplateClassName(), getStateEncodingOfArgument(), getTemplateContext());
                initialize();
                initializeLocalVars();
                initSubmitActions();
                initActions();
              }
              catch(utils.ValidationException ve){
                ThreadLocalPage.get().getValidationExceptions().add(ve.setName(ThreadLocalPage.get().getValidationContext()));
                ThreadLocalPage.get().setValidated(false);
                utils.Warning.warn("Validation failed in initialization of "+getTemplateSignature()+": "+ve.getErrorMessage());  
            skipThisTemplate = true;
          }
          catch(utils.MultipleValidationExceptions ve){
            for(utils.ValidationException vex : ve.getValidationExceptions()){
              ThreadLocalPage.get().getValidationExceptions().add(vex.setName(ThreadLocalPage.get().getValidationContext()));
              utils.Warning.warn("Validation failed in initialization of "+getTemplateSignature()+": "+vex.getErrorMessage());  
            }
            ThreadLocalPage.get().setValidated(false); 
            skipThisTemplate = true;
          }
        } 
    } 
    
    abstract protected boolean isAjaxTemplate();
    
    protected boolean isAjaxSubmitRequired(){
        return isAjaxSubmitRequired(false);
    }
    protected boolean isAjaxSubmitRequired(boolean ajaxmod){
      return ThreadLocalPage.get().isServingAsAjaxResponse //template is rendered in an action, e.g. with replace(placeholder,templatecall())
        || ThreadLocalPage.get().isAjaxRuntimeRequest() //current request came from ajax runtime
        || isAjaxTemplate() // template is defined with ajax modifier 'define ajax'
        || ajaxmod //submit buttons is defined with ajax modifier '[ajax]'
        || ThreadLocalPage.get().getFormIdent().equals(""); //submit is not in a form (normal browser submit won't work)
    }
}
