package utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.webdsl.WebDSLEntity;
import org.webdsl.lang.Environment;
import org.hibernate.Session;

public abstract class AbstractPageServlet{

    public static AbstractPageServlet getRequestedPage(){
        return ThreadLocalPage.get();
    }
    
    public abstract void serve(HttpServletRequest request, HttpServletResponse response, Map<String, String> parammap, Map<String, List<String>> parammapvalues, Map<String,utils.File> fileUploads);
    public abstract void serveAsAjaxResponse(AbstractPageServlet ps, Object[] ajaxarguments, Environment env, TemplateCall templateArg);
    public abstract void initializeBasics(AbstractPageServlet ps, Object[] args, Environment env);

    public boolean IsTemplate() { return false; }
    public boolean isServingAsAjaxResponse = false;
    
    private boolean passedThroughAjaxTemplate = false;
    public boolean passedThroughAjaxTemplate(){
      return passedThroughAjaxTemplate;
    }
    public void setPassedThroughAjaxTemplate(boolean b){
        passedThroughAjaxTemplate = b;
    }

    public abstract String getPageName();
    public abstract String getUniqueName();

    protected MessageDigest messageDigest = null;
    public  MessageDigest getMessageDigest(){
        if(messageDigest == null){
            try{
                messageDigest = MessageDigest.getInstance("MD5");
            }
            catch(NoSuchAlgorithmException ae)
            {
                System.out.println("MD5 not available: "+ae.getMessage());
                return null;
            }
        }
        return messageDigest;
    }
    
    protected utils.ActionClass actionToBeExecuted = null;
    public void setActionToBeExecuted(utils.ActionClass action){
        this.actionToBeExecuted = action;  	
    }
    public utils.ActionClass getActionToBeExecuted(){
        return actionToBeExecuted;
    }

    //TODO merge getActionTarget and getPageUrlWithParams
    public String getActionTarget() {
        if (isServingAsAjaxResponse){
            return this.getUniqueName();
        }
        return getPageName();
    }
    //TODO merge getActionTarget and getPageUrlWithParams
    public String getPageUrlWithParams(){ //used for action field in forms
        if(isServingAsAjaxResponse){
            return ThreadLocalServlet.getContextPath()+"/"+ThreadLocalPage.get().getActionTarget();
        }
        else{
            //this doesn't work with ajax template render from action, since an ajax template needs to submit to a different page than the original request
            return request.getRequestURL().toString();
        }
    }

    public boolean isPostRequest(){
        return ThreadLocalServlet.get().isPostRequest;
    }
    public boolean isNotPostRequest(){
        return !ThreadLocalServlet.get().isPostRequest;
    }
    public boolean isAjaxTemplateRequest(){
        return ThreadLocalServlet.get().getPages().get(ThreadLocalServlet.get().getRequestedPage()).isAjaxTemplate();
    }

    public abstract String getHiddenParams();
    public abstract String getHiddenPostParams();
    public abstract String getHiddenPostParamsJson();

    public javax.servlet.http.HttpSession session;

    public Environment envGlobalAndSession;

    public static void cleanupThreadLocals(){
        ThreadLocalAction.set(null);
        ThreadLocalEmailContext.set(null);
        ThreadLocalPage.set(null);
        ThreadLocalTemplate.set(null);
    }

    //templates scope
    public static Environment staticEnv = new Environment();

    public Environment env = new Environment(AbstractPageServlet.staticEnv);

    //emails
    protected static HashMap<String, Class<?>> emails = new HashMap<String, Class<?>>();
    public static HashMap<String, Class<?>> getEmails() {
        return emails;
    }
    public void sendEmail(String name, Object[] emailargs, Environment emailenv){
        EmailServlet temp = renderEmail(name,emailargs,emailenv);
        temp.send();
    }
    public EmailServlet renderEmail(String name, Object[] emailargs, Environment emailenv){
        EmailServlet temp = null;
        try
        { 
            temp = ((EmailServlet)getEmails().get(name).newInstance());
        }
        catch(IllegalAccessException iae)
        { 
            System.out.println("Problem in email template lookup: " + iae.getMessage());
        }
        catch(InstantiationException ie)
        { 
            System.out.println("Problem in email template lookup: " + ie.getMessage());
        }
        temp.render(emailargs, emailenv);
        return temp;
    }

    //render template function
    public String renderTemplate(String name, Object[] args, Environment env){
        TemplateServlet temp = null;
        try  { 
            temp = ((TemplateServlet)env.getTemplate(name).newInstance());
        }
        catch(IllegalAccessException iae)
        { 
            System.out.println("Problem in template lookup: " + iae.getMessage());
        }
        catch(InstantiationException ie)
        { 
            System.out.println("Problem in template lookup: " + ie.getMessage());
        }
        java.io.StringWriter s = new java.io.StringWriter();
        PrintWriter out = new java.io.PrintWriter(s);
        ThreadLocalOut.push(out);
        temp.render(args, env, null, null);
        ThreadLocalOut.popChecked(out);
        return s.toString();
    }

    //ref arg
    protected static HashMap<String, Class<?>> refargclasses = new HashMap<String, Class<?>>();
    public static HashMap<String, Class<?>> getRefArgClasses() {
        return refargclasses;
    }

    public abstract String getAbsoluteLocation();

    protected java.util.Deque<String> templateContext = new java.util.ArrayDeque<String>();
    public String getTemplateContextString() {
        java.lang.StringBuilder sb = new java.lang.StringBuilder();
        for(String s : templateContext){
            sb.append(s);
        }
        return sb.toString();
    }
    public void enterTemplateContext(String s) {
        templateContext.push(s);
    }
    public void leaveTemplateContext() {
        templateContext.pop();
    }
    //verifies that the correct context was popped
    public abstract void leaveTemplateContextChecked(String s);

    public void clearTemplateContext(){
        templateContext.clear();
    }

    // objects scheduled to be checked after action completes, filled by hibernate event listener in hibernate util class
    ArrayList<WebDSLEntity> entitiesValidatedAfterAction = new ArrayList<WebDSLEntity>();
    boolean allowAddingEntitiesForValidation = true;
    public void addEntityToValidateAfterAction(WebDSLEntity w){
        if(allowAddingEntitiesForValidation){ 
          entitiesValidatedAfterAction.add(w);
        }
    }
    public void validateEntitiesAfterAction(){
        allowAddingEntitiesForValidation = false; //adding entities must be disabled when checking is performed, new entities may be loaded for checks, but do not have to be checked themselves
        
        java.util.Set<WebDSLEntity> set = new java.util.HashSet<WebDSLEntity>(entitiesValidatedAfterAction);
        
        for(WebDSLEntity w : set){
            if(w.isChanged()){
              //System.out.println("validating: "+w);
              w.validateSave();
              //System.out.println("done validating");
            }
        }
    }
    
    protected List<utils.ValidationException> validationExceptions = new java.util.LinkedList<utils.ValidationException>();
    public List<utils.ValidationException> getValidationExceptions() {
        return validationExceptions;
    }
    public void addValidationException(String name, String message){
        validationExceptions.add(new ValidationException(name,message));
    }
    public List<utils.ValidationException> getValidationExceptionsByName(String name) {
        List<utils.ValidationException> list = new java.util.LinkedList<utils.ValidationException>();
        for(utils.ValidationException v : validationExceptions){
            if(v.getName().equals(name)){
                list.add(v);
            }
        }
        return list;
    }
    public List<String> getValidationErrorsByName(String name) {
        List<String> list = new java.util.ArrayList<String>();
        for(utils.ValidationException v : validationExceptions){
            if(v.getName().equals(name)){
                list.add(v.getErrorMessage());
            }
        }
        return list;
    }
    public boolean hasExecutedAction = false;
    public boolean hasExecutedAction(){ return hasExecutedAction; }
    public boolean hasNotExecutedAction(){ return !hasExecutedAction; }

    protected boolean abortTransaction = false;
    public boolean isTransactionAborted(){ return abortTransaction; }
    public void abortTransaction(){ abortTransaction = true; }

    public java.util.List<String> ignoreset= new java.util.ArrayList<String>();

    public boolean hibernateCacheCleared = false;

    protected java.util.List<String> javascripts = new java.util.ArrayList<String>();
    protected java.util.List<String[]> stylesheets = new java.util.ArrayList<String[]>();
    protected java.util.List<String> customHeads = new java.util.ArrayList<String>();
    protected java.util.Map<String,String> customHeadNoDuplicates = new java.util.HashMap<String,String>();
    public boolean useDojo = false;

    public void addJavascriptInclude(String filename) {
        if(!javascripts.contains(filename))
            javascripts.add(filename);
    }

    public void addStylesheetInclude(String filename) {
        if(!stylesheets.contains(filename)){
            String[] s = {filename,""};
            stylesheets.add(s);
        }
    }
    public void addStylesheetInclude(String filename, String media) {
        if(!stylesheets.contains(filename)){
            String[] s = {filename,media};
            stylesheets.add(s);
        }
    }

    public void addCustomHead(String header) {
        customHeads.add(header);
    }

    public void addCustomHead(String key, String header) {
        customHeadNoDuplicates.put(key, header);
    }

    protected abstract void initialize();
    protected abstract void conversion();
    protected abstract void loadArguments();
    protected abstract void initVarsAndArgs();

    public void clearHibernateCache() {
        // used to be only ' hibSession.clear(); ' but that doesn't revert already flushed changes.
        // since flushing now happens automatically when querying, this could produce wrong results.
        // e.g. output in page with validation errors shows changes that were not persisted to the db.
        // see regression test in test/succeed-web/validate-false-and-flush.app
        hibSession.getTransaction().rollback();

        /* http://community.jboss.org/wiki/sessionsandtransactions
         * Because Hibernate can't bind the "current session" to a transaction, as it does in a JTA environment,
         * it binds it to the current Java thread. It is opened when getCurrentSession() is called for the first
         * time, but in a "proxied" state that doesn't allow you to do anything except start a transaction. When
         * the transaction ends, either through commit or roll back, the "current" Session is closed automatically.
         * The next call to getCurrentSession() starts a new proxied Session, and so on. In other words,
         * the session is bound to the thread behind the scenes, but scoped to a transaction, just like in a JTA environment.
         */
        hibSession = openNewTransactionThroughGetCurrentSession();

        initVarsAndArgs();
        hibernateCacheCleared = true;
    }

    // workaround to get to static member of generated HibernateUtilConfigured class
    protected abstract org.hibernate.Session openNewTransactionThroughGetCurrentSession();

    protected Session hibSession;
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected Object[] args;

    public Session getHibSession() {
        return hibSession;
    }

    public HttpServletRequest getRequest() {
        return request;
    }

    public HttpServletResponse getResponse() {
        return response;
    }

    protected boolean validated=true;
    /*
     * when this is true, it can mean:
     *  1 no validation has been performed yet
     *  2 some validation has been performed without errors
     *  3 all validation has been performed without errors
     */
    public boolean isValid() {
        return validated;
    }
    public boolean isNotValid() {
        return !validated;
    }
    public void setValidated(boolean validated) {
        this.validated = validated;
    }
    
    /*
     * complete action regularly but rollback hibernate session
     * skips validation of entities at end of action, if validation messages are necessary
     * use cancel() instead of rollback()
     * can be used to replace templates with ajax without saving, e.g. for validation
     */
    protected boolean rollback = false;
    public boolean isRollback() {
        return rollback;
    }
    public void setRollback() {
        //by setting validated true, the action will succeed
        this.setValidated(true);
        //the session will be rolled back, to cancel persisting any changes
        this.rollback = true;
    }

    public List<String> failedCaptchaResponses = new ArrayList<String>();

    protected boolean inSubmittedForm = false;

    public boolean inSubmittedForm() {
        return inSubmittedForm;
    }

    public void setInSubmittedForm(boolean b) {
        this.inSubmittedForm = b;
    }

    public void clearParammaps(){
        parammap.clear();
        parammapvalues.clear();
        fileUploads.clear();
    }

    protected java.util.Map<String, String> parammap;
    public java.util.Map<String, String> getParammap() {
        return parammap;
    }

    protected Map<String,utils.File> fileUploads;
    public Map<String, utils.File> getFileUploads() {
        return fileUploads;
    }
    public utils.File getFileUpload(String key) {
        return fileUploads.get(key);
    }

    protected Map<String, List<String>> parammapvalues;
    public Map<String, List<String>> getParammapvalues() {
        return parammapvalues;
    }

    protected String pageTitle = "";
    public String getPageTitle() {
        return pageTitle;
    }
    public void setPageTitle(String pageTitle) {
        this.pageTitle = pageTitle;
    }

    protected String formIdent = "";
    public String getFormIdent() {
        return formIdent;
    }
    public void setFormIdent(String fi) {
        this.formIdent = fi;
    }

    protected boolean actionLinkUsed = false;
    public boolean isActionLinkUsed() {
        return actionLinkUsed;
    }
    public void setActionLinkUsed(boolean a) {
        this.actionLinkUsed = a;
    }

    protected boolean ajaxRuntimeRequest = false;
    public boolean isAjaxRuntimeRequest() {
        return ajaxRuntimeRequest;
    }
    public void setAjaxRuntimeRequest(boolean a) {
        ajaxRuntimeRequest = a;
    }

    protected String redirectUrl = "";
    public String getRedirectUrl() {
        return redirectUrl;
    }
    public void setRedirectUrl(String a) {
        this.redirectUrl = a;
    }

    protected String mimetype = "text/html; charset=UTF-8";
    protected boolean mimetypeChanged = false;
    public String getMimetype() {
        return mimetype;
    }
    public void setMimetype(String mimetype) {
        this.mimetype = mimetype;
        mimetypeChanged = true;
        enableRawoutput();
        disableTemplateSpans();
    }

    protected boolean ajaxActionExecuted = false;
    public boolean isAjaxActionExecuted() {
        return ajaxActionExecuted;
    }
    public void enableAjaxActionExecuted() {
        ajaxActionExecuted = true;
    }

    protected boolean rawoutput = false;
    public boolean isRawoutput() {
        return rawoutput;
    }
    public void enableRawoutput() {
        rawoutput = true;
    }
    public void disableRawoutput() {
        rawoutput = false;
    }

    protected String[] pageArguments = null;
    public void setPageArguments(String[] pa) {
        pageArguments = pa;
    }
    public String[] getPageArguments() {
        return pageArguments;
    }

    protected String httpMethod = null;
    public void setHttpMethod(String httpMethod) {
        this.httpMethod = httpMethod;
    }
    public String getHttpMethod() {
        return httpMethod;
    }

    protected boolean templateSpans = true;
    public boolean templateSpans() {
        return templateSpans;
    }
    public void disableTemplateSpans() {
        templateSpans = false;
    }

    protected utils.File download = null;
    public void setDownload(utils.File file){
        this.download = file;
    }
    public boolean isDownloadSet(){
        return this.download != null;
    }

    protected void download()
    {
        /*
  Long id = download.getId();
  org.hibernate.Session hibSession = HibernateUtilConfigured.getSessionFactory().openSession();
  hibSession.beginTransaction();
  hibSession.setFlushMode(org.hibernate.FlushMode.MANUAL);
  utils.File download = (utils.File)hibSession.load(utils.File.class,id);
         */
        try
        {
            javax.servlet.ServletOutputStream outstream;

            outstream = response.getOutputStream();

            java.sql.Blob blob = download.getContent();
            java.io.InputStream in;

            in = blob.getBinaryStream();
            response.setContentType(download.getContentType());
            response.setHeader("Content-Disposition", "attachment; filename=" + download.getFileName());
            java.io.BufferedOutputStream bufout = new java.io.BufferedOutputStream(outstream);
            byte bytes[] = new byte[32768];
            int index = in.read(bytes, 0, 32768);
            while(index != -1)
            {
                bufout.write(bytes, 0, index);
                index = in.read(bytes, 0, 32768);
            }
            bufout.flush();
        }
        catch(java.sql.SQLException ex)
        {
            System.out.println("exception in download serve");
            ex.printStackTrace();
        }
        catch (IOException ex) {
            System.out.println("exception in download serve");
            ex.printStackTrace();
        }
        /*
  hibSession.flush();
  hibSession.getTransaction().commit();
         */
    }

    //data validation

    public java.util.LinkedList<String> validationContext = new java.util.LinkedList<String>();

    public String getValidationContext() {
      //System.out.println("using" + validationContext.peek());
      return validationContext.peek();
    }

    public void enterValidationContext(String ident) {
      validationContext.add(ident);
      //System.out.println("entering" + ident);
    }

    public void leaveValidationContext() {
      /*String s = */ validationContext.removeLast();
      //System.out.println("leaving" +s);
    }

    public boolean inValidationContext() {
      return validationContext.size() != 0;
    }

    //messages

    private List<String> incomingSuccessMessages = new java.util.LinkedList<String>();

    public List<String> getIncomingSuccessMessages() {
      return incomingSuccessMessages;
    }

    private List<String> outgoingSuccessMessages = new java.util.LinkedList<String>();

    public List<String> getOutgoingSuccessMessages() {
      return outgoingSuccessMessages;
    }

    protected abstract void renderIncomingSuccessMessages();

    protected void storeOutgoingMessagesInHttpSession(){
      if(outgoingSuccessMessages.size() > 0){
        session.setAttribute("___messages___",outgoingSuccessMessages);
      }
    }
    @SuppressWarnings("unchecked")
    protected void retrieveIncomingMessagesFromHttpSession(){
      List<String> temp = (List<String>) session.getAttribute("___messages___");
      if(temp != null){
        incomingSuccessMessages = temp;
      }
    }

    //form

    public boolean formRequiresMultipartEnc = false;

    //formGroup

    public String formGroupLeftSize = "150";

    //public java.util.Stack<utils.FormGroupContext> formGroupContexts = new java.util.Stack<utils.FormGroupContext>();

    public utils.FormGroupContext getFormGroupContext() {
      return (utils.FormGroupContext) tableContexts.peek();
    }

    public void enterFormGroupContext() {
      tableContexts.push(new utils.FormGroupContext());
    }

    public void leaveFormGroupContext() {
      tableContexts.pop();
    }

    public boolean inFormGroupContext() {
      return !tableContexts.empty() && tableContexts.peek() instanceof utils.FormGroupContext;
    }

    public java.util.Stack<String> formGroupContextClosingTags = new java.util.Stack<String>();

    public void formGroupContextsCheckEnter(PrintWriter out) {
      if(inFormGroupContext()){
        utils.FormGroupContext temp = getFormGroupContext();
        if(!temp.isInDoubleColumnContext()){ // ignore defaults when in scope of a double column
          if(!temp.isInColumnContext()){ //don't nest left and right
            temp.enterColumnContext();
            if(temp.isInLeftContext()) {
              out.print("<div style=\"clear:left; float:left; width: " + formGroupLeftSize + "px\">");
              formGroupContextClosingTags.push("left");
              temp.toRightContext();
            }
            else {
              out.print("<div style=\"float: left;\">");
              formGroupContextClosingTags.push("right");
              temp.toLeftContext();
            }
          }
          else{
            formGroupContextClosingTags.push("none");
          }
        }
      }
    }

    public void formGroupContextsCheckLeave(PrintWriter out) {
      if(inFormGroupContext()){
        utils.FormGroupContext temp = getFormGroupContext();
        if(!temp.isInDoubleColumnContext()) {
          String tags = formGroupContextClosingTags.pop();
          if(tags.equals("left")){
            //temp.toRightContext();
            temp.leaveColumnContext();
            out.print("</div>");
          }
          else if(tags.equals("right")){
            //temp.toLeftContext();
            temp.leaveColumnContext();
            out.print("</div>");
          }
        }
      }
    }

    public void formGroupContextsDisplayLeftEnter(PrintWriter out) {
        if(inFormGroupContext()){
          utils.FormGroupContext temp = getFormGroupContext();
          if(!temp.isInColumnContext()){
            temp.enterColumnContext();
            out.print("<div style=\"clear:left; float:left; width: " + formGroupLeftSize + "px\">");
            formGroupContextClosingTags.push("left");
            temp.toRightContext();
          }
          else{
            formGroupContextClosingTags.push("none");
          }
        }
      }

      public void formGroupContextsDisplayRightEnter(PrintWriter out) {
        if(inFormGroupContext()){
          utils.FormGroupContext temp = getFormGroupContext();
          if(!temp.isInColumnContext()){
            temp.enterColumnContext();
            out.print("<div style=\"float: left;\">");
            formGroupContextClosingTags.push("right");
            temp.toLeftContext();
          }
          else{
            formGroupContextClosingTags.push("none");
          }
        }
      }

      //label

      public String getLabelString() {
          return getLabelStringForTemplateContext(ThreadLocalTemplate.get().getUniqueId());
      }
      public java.util.Stack<String> labelStrings = new java.util.Stack<String>();
      public java.util.Set<String> usedPageElementIds = new java.util.HashSet<String>();
      public static java.util.Random rand = new java.util.Random();
      //avoid duplicate ids; if multiple inputs are in a label, only the first is connected to the label
      public String getLabelStringOnce() {
        String s = labelStrings.peek();
        if(usedPageElementIds.contains(s)){
          do{
            s += rand.nextInt();
          }
          while(usedPageElementIds.contains(s));
        }
        usedPageElementIds.add(s);
        return s;
      }
      public java.util.Map<String,String> usedPageElementIdsTemplateContext = new java.util.HashMap<String,String>();
      //subsequent calls from the same defined template (e.g. in different phases) should produce the same id
      public String getLabelStringForTemplateContext(String context) {
          String labelid = usedPageElementIdsTemplateContext.get(context);
          if(labelid == null){
            labelid = getLabelStringOnce();
            usedPageElementIdsTemplateContext.put(context, labelid);
          }
          return labelid;
      }
      
      public void enterLabelContext(String ident) {
        labelStrings.push(ident);
      }

      public void leaveLabelContext() {
        labelStrings.pop();
      }

      public boolean inLabelContext() {
        return !labelStrings.empty();
      }

      //section

      public int sectionDepth = 0;

      public int getSectionDepth() {
        return sectionDepth;
      }

      public void enterSectionContext() {
        sectionDepth++;
      }

      public void leaveSectionContext() {
        sectionDepth--;
      }

      public boolean inSectionContext() {
        return sectionDepth > 0;
      }

      //table

      public java.util.Stack<Object> tableContexts = new java.util.Stack<Object>();

      public utils.TableContext getTableContext() {
        return (utils.TableContext) tableContexts.peek();
      }

      public void enterTableContext() {
        tableContexts.push(new utils.TableContext());
      }

      public void leaveTableContext() {
        tableContexts.pop();
      }

      public boolean inTableContext() {
        return !tableContexts.empty() && tableContexts.peek() instanceof utils.TableContext;
      }

      public java.util.Stack<String> tableContextClosingTags = new java.util.Stack<String>();

      //separate row and column checks, used by label
      public void rowContextsCheckEnter(PrintWriter out) {
        if(inTableContext()){
          utils.TableContext x_temp = getTableContext();
          if(!x_temp.isInRowContext()) {
            out.print("<tr>");
            x_temp.enterRowContext();
            tableContextClosingTags.push("</tr>");
          }
          else{
            tableContextClosingTags.push("");
          }
        }
      }
      public void rowContextsCheckLeave(PrintWriter out) {
        if(inTableContext()){
          utils.TableContext x_temp = getTableContext();
          String tags = tableContextClosingTags.pop();
          if(tags.equals("</tr>")){
            x_temp.leaveRowContext();
            out.print(tags);
          }
        }
      }
      public void columnContextsCheckEnter(PrintWriter out) {
        if(inTableContext()){
          utils.TableContext x_temp = getTableContext();
          if(x_temp.isInRowContext() && !x_temp.isInColumnContext()) {
            out.print("<td>");
            x_temp.enterColumnContext();
            tableContextClosingTags.push("</td>");
          }
          else{
            tableContextClosingTags.push("");
          }
        }
      }
      public void columnContextsCheckLeave(PrintWriter out) {
        if(inTableContext()){
          utils.TableContext x_temp = getTableContext();
          String tags = tableContextClosingTags.pop();
          if(tags.equals("</td>")){
            x_temp.leaveColumnContext();
            out.print(tags);
          }
        }
      }

      //request vars

      public HashMap<String, Object> requestScopedVariables = new HashMap<String, Object>();

      public void initRequestVars(){
        initRequestVars(null);
      }

      public abstract void initRequestVars(PrintWriter out);

}