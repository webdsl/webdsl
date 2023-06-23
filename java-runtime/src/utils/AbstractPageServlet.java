package utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.webdsl.WebDSLEntity;
import org.webdsl.lang.Environment;
import org.webdsl.logging.Logger;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

public abstract class AbstractPageServlet{

    protected abstract void renderDebugJsVar(PrintWriter sout);
    protected abstract boolean logSqlCheckAccess();
    protected abstract void initTemplateClass();
    protected abstract boolean isActionSubmit();
    protected abstract String[] getUsedSessionEntityJoins();
    protected TemplateServlet templateservlet = null;
    protected abstract org.webdsl.WebDSLEntity getRequestLogEntry();
    protected abstract void addPrincipalToRequestLog(org.webdsl.WebDSLEntity rle);
    protected abstract void addLogSqlToSessionMessages();
    public Session hibernateSession = null;
    protected static Pattern isMarkupLangMimeType= Pattern.compile("html|xml$");
    protected static Pattern baseURLPattern= Pattern.compile("(^\\w{0,6})(://[^/]+)");
    protected AbstractPageServlet commandingPage = this;
    public boolean isReadOnly = false;
    public boolean isWebService(){ return false; }
    public String placeholderId = "1";
    
    static{
    	ajax_js_include_name = "ajax.js";
    }
    
    public void serve(HttpServletRequest request, HttpServletResponse httpServletResponse, Map<String, String> parammap, Map<String, List<String>> parammapvalues, Map<String,List<utils.File>> fileUploads) throws Exception
    {
      initTemplateClass();

      this.startTime = System.currentTimeMillis();
      ThreadLocalPage.set(this);
      this.request=request;
      this.httpServletResponse = httpServletResponse;
      this.response = new ResponseWrapper(httpServletResponse);
      this.parammap = parammap;
      this.parammapvalues = parammapvalues;
      this.fileUploads=fileUploads;

      String ajaxParam = parammap.get( "__ajax_runtime_request__" );
      if( ajaxParam != null ){
        this.setAjaxRuntimeRequest( true );
        if( ajaxParam != "1" ){
          placeholderId = ajaxParam;
        }
      }

      org.webdsl.WebDSLEntity rle = getRequestLogEntry();
      org.apache.logging.log4j.ThreadContext.put("request", rle.getId().toString());
      org.apache.logging.log4j.ThreadContext.put("template", "/" + getPageName());
      utils.RequestAppender reqAppender = null;
      if(parammap.get("disableopt") != null){
        this.isOptimizationEnabled = false;
      }
      if(parammap.get("logsql") != null){
    	  this.isLogSqlEnabled = true;
    	  this.isPageCacheDisabled = true;
    	  reqAppender = utils.RequestAppender.getInstance();
      }
      if(reqAppender != null){
    	  reqAppender.addRequest(rle.getId().toString());
      }
      if(parammap.get("nocache") != null){
    	  this.isPageCacheDisabled = true;
      }
      initRequestVars();
      hibernateSession = utils.HibernateUtil.getCurrentSession();
      hibernateSession.beginTransaction();
      if(isReadOnly){
    	  hibernateSession.setFlushMode(org.hibernate.FlushMode.MANUAL);
      }
      else{
    	  hibernateSession.setFlushMode(org.hibernate.FlushMode.COMMIT);
      }
      try
      {
        StringWriter s = new StringWriter();
        PrintWriter out = new PrintWriter(s);
        ThreadLocalOut.push(out);

        ThreadLocalServlet.get().loadSessionManager(hibernateSession, getUsedSessionEntityJoins());
        ThreadLocalServlet.get().retrieveIncomingMessagesFromHttpSession();

        initVarsAndArgs();
        enterPlaceholderIdContext();
        
        if(isActionSubmit()) {

          if(parammap.get("__action__link__") != null) {
            this.setActionLinkUsed(true);
          }
          
          templateservlet.storeInputs(null, args, new Environment(envGlobalAndSession), null);
          clearTemplateContext();

          //storeinputs also finds which action is executed, since validation might be ignored using [ignore-validation] on the submit
          boolean ignoreValidation = actionToBeExecutedHasDisabledValidation;

          if (!ignoreValidation){
            templateservlet.validateInputs (null, args, new Environment(envGlobalAndSession), null);
            clearTemplateContext();
          }
          if(validated){
            templateservlet.handleActions(null, args, new Environment(envGlobalAndSession), null);
            clearTemplateContext();
          }
        }

        if(isNotValid()){
      	  // mark transaction so it will be aborted at the end
          // entered form data can be used to update the form on the client with ajax, taking into account if's and other control flow template elements
          // this also means that data in vars/args and hibernate session should not be cleared until form is rendered
          abortTransaction();
        }

        String outstream = s.toString();
        if(download != null) { //File.download() excecuted in action
          download();
        }
        else {
          boolean isAjaxResponse = true;
          // regular render, or failed action render
          if( hasNotExecutedAction() || isNotValid() ){
            // ajax replace performed during validation, assuming that handles all validation
        	// all inputajax templates use rollback() to prevent making actual changes -> check for isRollback()
            if(isAjaxRuntimeRequest() && outstream.length() > 0 && isRollback()){
              response.getWriter().write("[");
              response.getWriter().write(outstream);
              if(this.isLogSqlEnabled()){ // Cannot use (parammap.get("logsql") != null) here, because the parammap is cleared by actions
                if(logSqlCheckAccess()){
                  response.getWriter().write("{\"action\":\"logsql\",\"value\":\"" + org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(utils.HibernateLog.printHibernateLog(this, "ajax")) + "\"}");
                }
                else{
                  response.getWriter().write("{\"action\":\"logsql\",\"value\":\"Access to SQL logs was denied.\"}");
                }
                response.getWriter().write(",");
              }
              response.getWriter().write("{}]");
            }
            // action called but no action found
            else if( !isWebService() && isValid() && isActionSubmit() ){
              org.webdsl.logging.Logger.error("Error: server received POST request but was unable to dispatch to a proper action (" + getRequestURL() + ")" );
              httpServletResponse.setStatus( 404 );
              response.getWriter().write("404 \n Error: server received POST request but was unable to dispatch to a proper action");
            }
            // action inside ajax template called and failed
            else if( isAjaxTemplateRequest() && isActionSubmit() ){
              StringWriter s1 = renderPageOrTemplateContents();
              response.getWriter().write("[{\"action\":\"replace\",\"id\":{\"type\":\"enclosing-placeholder\"},\"value\":\"" + org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(s1.toString()) + "\"}]");
            }
            //actionLink or ajax action used (request came through js runtime), and action failed
            else if( isActionLinkUsed() || isAjaxRuntimeRequest() ){
              validationFormRerender = true;
              renderPageOrTemplateContents();
              if(submittedFormId != null){
                response.getWriter().write("[{\"action\":\"replace\",\"id\":\"" + submittedFormId + "\",\"value\":\"" + org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript( submittedFormContent ) + "\"}]");
              }
              else{
            	response.getWriter().write("[{\"action\":\"replace\",\"id\":{submitid:'" + submittedSubmitId + "'},\"value\":\"" + org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript( submittedFormContent ) + "\"}]");  
              }
            }
            // 1 regular render without any action being executed
            // 2 regular action submit, and action failed
            // 3 redirect in page init
            // 4 download in page init
            else{
              isAjaxResponse = false;
              renderOrInitAction();
            }
          }
          // successful action, always redirect, no render
          else {
            // actionLink or ajax action used and replace(placeholder) invoked
            if( isReRenderPlaceholders() ){
                StringBuilder commands = new StringBuilder("[");
                templateservlet.validateInputs (null, args, new Environment(envGlobalAndSession), null);
                clearTemplateContext();
                renderDynamicFormWithOnlyDirtyData = true;
                shouldReInitializeTemplates = true;
                renderPageOrTemplateContents(); // content of placeholders is collected in reRenderPlaceholdersContent map
                
                //For now we do not support dynamically loading of resources in case of a rerendered placeholder,
                //because this would try to load the js/css resources from the whole page while only a part gets rerendered
//                if(this.javascripts.size() > 0) {
//                  commands.append( requireJSCommand() ).append(",");
//                }
//                if(this.stylesheets.size() > 0) {
//                  commands.append( requireCSSCommand() ).append(",");
//                }
                
                boolean addComma = false;
                for(String ph : reRenderPlaceholders){
                    if(addComma){ commands.append(","); }
                    else { addComma = true; }
                    commands.append("{\"action\":\"replace\",\"id\":\"")
                	            .append(ph)
                	            .append("\",\"value\":\"")
                              .append(org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(reRenderPlaceholdersContent.get(ph)))
                              .append("\"}");
                }
                if( outstream.length() > 0 ){
                  commands.append( "," + outstream.substring(0, outstream.length() - 1) ); // Other ajax updates, such as clear(ph). Done after ph rerendering to allow customization.
                }
                commands.append("]");
                response.getWriter().write( commands.toString() );
            }
            //hasExecutedAction() && isValid()
            else if( isAjaxRuntimeRequest() ){
              PrintWriter responseWriter = response.getWriter();
              responseWriter.write("[");
              if(this.javascripts.size() > 0) {
                responseWriter.write( requireJSCommand() );
                responseWriter.write(",");
              }
              if(this.stylesheets.size() > 0) {
                responseWriter.write( requireCSSCommand() );
                responseWriter.write(",");
              }
              responseWriter.write(outstream);
              if(this.isLogSqlEnabled()){ // Cannot use (parammap.get("logsql") != null) here, because the parammap is cleared by actions
                    if(logSqlCheckAccess()){
                      responseWriter.write("{\"action\":\"logsql\",\"value\":\"" + org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(utils.HibernateLog.printHibernateLog(this, "ajax")) + "\"}");
                    }
                    else{
                      responseWriter.write("{\"action\":\"logsql\",\"value\":\"Access to SQL logs was denied.\"}");
                    }
                    responseWriter.write(",");
              }
              if( this.validateFailedBeforeRollback ){
                responseWriter.write("{\"action\":\"skip_next_action\"}]");
              }
              else {
                responseWriter.write("{}]");
              }
            }
            else if( isActionLinkUsed() ){
              //action link also uses ajax when ajax is not enabled
              //, send only redirect location, so the client can simply set
              // window.location = req.responseText;
              response.getWriter().write("[{\"action\":\"relocate\",\"value\":\""+this.getRedirectUrl() + "\"}]");
            } else {
              isAjaxResponse = false;
            }
            if(!isAjaxRuntimeRequest()) {
              addLogSqlToSessionMessages();
            }
            //else: action successful + no validation error + regular submit
            //        -> always results in a redirect, no further action necessary here
          }
          
          if(isAjaxResponse){
            response.setContentType("application/json");
          }
          
        }

        updatePageRequestStatistics();

        hibernateSession = utils.HibernateUtil.getCurrentSession();
        if( isTransactionAborted() || isRollback() ){
          try{
              hibernateSession.getTransaction().rollback();
              response.sendContent();
          }
          catch (org.hibernate.SessionException e){
            if(!e.getMessage().equals("Session is closed!")){ // closed session is not an issue when rolling back
              throw e;
            }
          }
        }
        else {
          ThreadLocalServlet.get().storeOutgoingMessagesInHttpSession( !isRedirected() || isPostRequest() );
          addPrincipalToRequestLog(rle);
          if(!this.isAjaxRuntimeRequest()){
            ThreadLocalServlet.get().setEndTimeAndStoreRequestLog(utils.HibernateUtil.getCurrentSession());
          }
          ThreadLocalServlet.get().setCookie(hibernateSession);
          if(isReadOnly || !hasWrites){ // either page has read-only modifier, or no writes have been detected
            hibernateSession.getTransaction().rollback();
          }
          else{
       	    hibernateSession.flush();
        	validateEntities();
            hibernateSession.getTransaction().commit();
            invalidatePageCacheIfNeeded();
          }
          if(exceptionInHibernateInterceptor != null){
          	throw exceptionInHibernateInterceptor;
          }
          response.sendContent();
        }
        ThreadLocalOut.popChecked(out);
      }

      catch(utils.MultipleValidationExceptions mve){
    	  String url = getRequestURL();
    	  org.webdsl.logging.Logger.error("Validation exceptions occurred while handling request URL [ " + url + " ]. Transaction is rolled back.");
    	  for(utils.ValidationException vex : mve.getValidationExceptions()){
    		  org.webdsl.logging.Logger.error( "Validation error: " + vex.getErrorMessage() , vex );
    	  }
    	  hibernateSession.getTransaction().rollback();
    	  setValidated(false);
    	  throw mve;
      }
      catch(utils.EntityNotFoundException enfe) {
        org.webdsl.logging.Logger.error( enfe.getMessage() + ". Transaction is rolled back." );
        if(hibernateSession.isOpen()){
          hibernateSession.getTransaction().rollback();
        }
        throw enfe;
      }
      catch (Exception e) {
        String url = getRequestURL();
        org.webdsl.logging.Logger.error("exception occurred while handling request URL [ " + url + " ]. Transaction is rolled back.");
        org.webdsl.logging.Logger.error("exception message: "+e.getMessage(), e);
        if(hibernateSession.isOpen()){
          hibernateSession.getTransaction().rollback();
        }
        throw e;

      }
      finally{
        cleanupThreadLocals();
        org.apache.logging.log4j.ThreadContext.remove("request");
        org.apache.logging.log4j.ThreadContext.remove("template");
        if(reqAppender != null) reqAppender.removeRequest(rle.getId().toString());
      }
    }
    
    // LoadingCache is thread-safe
    public static boolean pageCacheEnabled = utils.BuildProperties.getNumCachedPages() > 0;
    public static Cache<String, CacheResult> cacheAnonymousPages =
    		CacheBuilder.newBuilder()
    		.maximumSize(utils.BuildProperties.getNumCachedPages()).build();
    public boolean invalidateAllPageCache = false;
    protected boolean shouldTryCleanPageCaches = false;
    public String invalidateAllPageCacheMessage;
    public void invalidateAllPageCache(String entityname){
    	commandingPage.invalidateAllPageCacheInternal(entityname);
    }
    private void invalidateAllPageCacheInternal(String entityname){
    	invalidateAllPageCache = true;
    	invalidateAllPageCacheMessage = entityname;
    }
    public void shouldTryCleanPageCaches(){
  	  commandingPage.shouldTryCleanPageCachesInternal();
    }
    private void shouldTryCleanPageCachesInternal(){
    	shouldTryCleanPageCaches = true;
    }
    
    public static void doInvalidateAllPageCache( String triggerReason ) {
      Logger.info( "All page caches invalidated, triggered by: " + triggerReason );
      cacheAnonymousPages.invalidateAll();
      cacheUserSpecificPages.invalidateAll();
    }
    public static void doInvalidateUserSpecificPageCache( String triggerReason ) {
      Logger.info( "User-specific page caches invalidated, triggered by: " + triggerReason );
      cacheUserSpecificPages.invalidateAll();
    }

    public static Cache<String, CacheResult> cacheUserSpecificPages =
    		CacheBuilder.newBuilder()
    		.maximumSize(utils.BuildProperties.getNumCachedPages()).build();
    public boolean invalidateUserSpecificPageCache = false;
    public String invalidateUserSpecificPageCacheMessage;
    
    public void invalidateUserSpecificPageCache(String entityname){
    	commandingPage.invalidateUserSpecificPageCacheInternal(entityname);
    }
    private void invalidateUserSpecificPageCacheInternal(String entityname){
    	invalidateUserSpecificPageCache = true;
    	String propertySetterTrace = Warning.getStackTraceLineAtIndex(4);
    	invalidateUserSpecificPageCacheMessage = entityname + " - " + propertySetterTrace;
    }
    
    public boolean pageCacheWasUsed = false;

    public void invalidatePageCacheIfNeeded(){
    	if(pageCacheEnabled && shouldTryCleanPageCaches){
	    	if(invalidateAllPageCache){
	    	  doInvalidateAllPageCache("change in: "+invalidateAllPageCacheMessage);
	    	}
	    	else if(invalidateUserSpecificPageCache){
	    		doInvalidateUserSpecificPageCache("change in: "+invalidateUserSpecificPageCacheMessage);
	    	}
    	}
    }

    public void renderOrInitAction() throws IOException{
    	String key = getRequestURL();
    	String s = "";
    	Cache<String, CacheResult> cache = null;
    	AbstractDispatchServletHelper servlet = ThreadLocalServlet.get();
    	if( // not using page cache if:
    		this.isPageCacheDisabled // ?nocache added to URL
    		|| this.isPostRequest() // post parameters are not included in cache key
    		|| isNotValid() // data validation errors need to be rendered
    		|| !servlet.getIncomingSuccessMessages().isEmpty() // success messages need to be rendered
    	){
    		StringWriter renderedContent = renderPageOrTemplateContents();
    		if(!mimetypeChanged){
    			s = renderResponse(renderedContent);
    		}
    		else{
    			s = renderedContent.toString();
    		}
    	}
    	else{ // using page cache
    		if( // use user-specific page cache if:
    			servlet.sessionHasChanges() // not necessarily login, any session data changes can be included in a rendered page
    		    || webdsl.generated.functions.loggedIn_.loggedIn_() // user might have old session from before application start, this check is needed to avoid those logged in pages ending up in the anonymous page cache
    		){
    			key = key + servlet.getSessionManager().getId();
    			cache = cacheUserSpecificPages;
    		}
    		else{
    			cache = cacheAnonymousPages;
    		}
    		try{
    			pageCacheWasUsed = true;
    			CacheResult result = cache.get(key,
    			new Callable<CacheResult>(){
    				public CacheResult call(){
    					// System.out.println("key not found");
    					pageCacheWasUsed = false;
    					StringWriter renderedContent = renderPageOrTemplateContents();
    					CacheResult result = new CacheResult();
    					if(!mimetypeChanged){
    						result.body = renderResponse(renderedContent);
    					}
    					else{
    						result.body = renderedContent.toString();
    					}
    					result.mimetype = getMimetype();
    					return result;
    				}
    			});
    			s = result.body;
    			setMimetype(result.mimetype);
    		}
    		catch(java.util.concurrent.ExecutionException e){
    			e.printStackTrace();
    		}
    	}

    	// redirect in init action can be triggered with GET request, the render call in the line above will execute such inits
    	if( !isPostRequest() && isRedirected() ){
    		redirect();
    		if(cache != null){ cache.invalidate(key); } 
    	}
    	else if( download != null ){ //File.download() executed in page/template init block
    		download();
    		if(cache != null){ cache.invalidate(key); } // don't cache binary file response in this page response cache, can be cached on client with expires header
    	}
    	else{
    		response.setContentType(getMimetype());
    		PrintWriter sout = response.getWriter(); //reponse.getWriter() must be called after file download checks
    		sout.write(s);
    	}
    }
    
    public boolean renderDynamicFormWithOnlyDirtyData = false;

    public StringWriter renderPageOrTemplateContents(){
        if(isTemplate() && !ThreadLocalServlet.get().isPostRequest){ throw new utils.AjaxWithGetRequestException(); }
        StringWriter s = new StringWriter();
        PrintWriter out = new PrintWriter(s);

        if(getParammap().get("dynamicform") == null){
          // regular pages and forms
          if(isNotValid()){
        	clearHibernateCache();
          }
          ThreadLocalOut.push(out);
          templateservlet.render(null, args, new Environment(envGlobalAndSession), null);
          ThreadLocalOut.popChecked(out);  	
        }
        else{
          shouldReInitializeTemplates = false;
          // dynamicform uses submitted variable data to process form content
          // render form with newly entered data, rest with the current persisted data
          if(isNotValid() && !renderDynamicFormWithOnlyDirtyData){
            StringWriter theform = new StringWriter();
            PrintWriter pwform = new PrintWriter(theform);
            ThreadLocalOut.push(pwform);
            // render, when encountering submitted form save in abstractpage
            validationFormRerender = true;
            templateservlet.render(null, args, new Environment(envGlobalAndSession), null);
            ThreadLocalOut.popChecked(pwform);

            clearHibernateCache();
          }
          ThreadLocalOut.push(out);
          // render, when isNotValid and encountering submitted form render old
          templateservlet.render(null, args, new Environment(envGlobalAndSession), null);
          ThreadLocalOut.popChecked(out);
        }
        return s;
    }
    
    public StringWriter renderPageOrTemplateContentsSingle(){
        if(isTemplate() && !ThreadLocalServlet.get().isPostRequest){ throw new utils.AjaxWithGetRequestException(); }
        StringWriter s = new StringWriter();
        PrintWriter out = new PrintWriter(s);

        ThreadLocalOut.push(out);
          templateservlet.render(null, args, new Environment(envGlobalAndSession), null);
          ThreadLocalOut.popChecked(out);
       
          return s;
    }
    
    
    private boolean validationFormRerender = false;
    public boolean isValidationFormRerender(){
        return validationFormRerender;
    }
    public String submittedFormContent = null;
    public String submittedFormId = null;
    public String submittedSubmitId = null;
    
    // helper methods that enable a submit without enclosing form to be ajax-refreshed when validation error occurs
    protected StringWriter submitWrapSW;
    protected PrintWriter submitWrapOut;
    public void submitWrapOpenHelper(String submitId){
    	if( ! inSubmittedForm && validationFormRerender && request != null && getParammap().get(submitId) != null ){
    		submittedSubmitId = submitId;
    		submitWrapSW = new java.io.StringWriter();
    		submitWrapOut = new java.io.PrintWriter(submitWrapSW);
    		ThreadLocalOut.push(submitWrapOut);
    		ThreadLocalOut.peek().print("<span submitid=" + submitId + ">");
    	}
    }
    public void submitWrapCloseHelper(){
    	if( ! inSubmittedForm && validationFormRerender && submitWrapSW != null ){
    		ThreadLocalOut.peek().print("</span>");
    		ThreadLocalOut.pop();
    		submittedFormContent = submitWrapSW.toString();
    		submitWrapSW = null;
    	}
    }
	private static String ajax_js_include_name;
	
    public String renderResponse(StringWriter s) {
    	StringWriter sw = new StringWriter();
    	PrintWriter sout = new PrintWriter(sw);
        ThreadLocalOut.push(sout);

        addJavascriptInclude( utils.IncludePaths.jQueryJS() );
        addJavascriptInclude( ajax_js_include_name );
        
        sout.println("<!DOCTYPE html>");
        sout.println("<html>");
        sout.println("<head>");
        
        if( !customHeadNoDuplicates.containsKey( "viewport" ) ) {
          sout.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\">");
        }
        if( !customHeadNoDuplicates.containsKey( "contenttype" ) ) {
          sout.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
        }
        if( !customHeadNoDuplicates.containsKey( "favicon" ) ) {
          sout.println("<link href=\""+ThreadLocalPage.get().getAbsoluteLocation()+ CachedResourceFileNameHelper.fav_ico_link_tag_suffix);
        }
        if( !customHeadNoDuplicates.containsKey( "defaultcss" ) ) {
          sout.println("<link href=\""+ThreadLocalPage.get().getAbsoluteLocation()+ CachedResourceFileNameHelper.common_css_link_tag_suffix);
        }
        
        sout.println("<title>"+getPageTitle().replaceAll("<[^>]*>","")+"</title>");

        renderDebugJsVar(sout);
        sout.println("<script type=\"text/javascript\">var contextpath=\""+ThreadLocalPage.get().getAbsoluteLocation()+"\";</script>");

        for(String sheet : this.stylesheets) {
          String href = computeResourceSrc("stylesheets", sheet);
            sout.print("<link rel=\"stylesheet\" href=\""+ href + "\" type=\"text/css\" />");
        }
        for(String script : this.javascripts) {
        	String src = computeResourceSrc("javascript", script);
            sout.println("<script type=\"text/javascript\" src=\"" + src + "\"></script>");
        }
        for(Map.Entry<String,String> headEntry : customHeadNoDuplicates.entrySet()) {
//            sout.println("<!-- " + headEntry.getKey() + " -->");
            sout.println(headEntry.getValue());
        }
        sout.println("</head>");

        sout.print("<body id=\""+this.getPageName()+"\"");
        for(String attribute : this.bodyAttributes) {
        	sout.print(attribute);
        }
        sout.print(">");

        renderLogSqlMessage();
        renderIncomingSuccessMessages();

        s.flush();

        sout.write(s.toString());

        if(this.isLogSqlEnabled()){
            if(logSqlCheckAccess()){
                sout.print("<hr/><div class=\"logsql\">");
                sout.print("<script type=\"text/javascript\">$('a.navigate').on('click', function(event) { event.preventDefault(); window.location.href = $(this).attr('href') + '?logsql' })</script>");
                utils.HibernateLog.printHibernateLog(sout, this, null);
                sout.print("</div>");
            }
            else{
                sout.print("<hr/><div class=\"logsql\">Access to SQL logs was denied.</div>");
            }
        }

        for(String script : this.tailJavascripts) {
        	String src = computeResourceSrc("javascript", script);
            sout.println("<script type=\"text/javascript\" src=\"" + src + "\"></script>");
        }
        sout.print("</body>");
        sout.println("</html>");

        ThreadLocalOut.popChecked(sout);
        return sw.toString();
    }

    private String computeResourceSrc(String resourceDirName, String url) {
        if(url.startsWith("//") || url.startsWith("http://") || url.startsWith("https://")) {
            return url;
        } else {
            String hashedName = CachedResourceFileNameHelper.getNameWithHash(resourceDirName, url);
            return ThreadLocalPage.get().getAbsoluteLocation()+"/"+resourceDirName+"/"+hashedName;
        }
    }
    
    private String requireJSCommand() {
      StringBuilder aStr = new StringBuilder("{ \"action\":\"require_js\", \"value\": [");
      boolean addComma = false;
      for(String script : this.javascripts) {
        if(addComma) {
          aStr.append(",");
        } else{
          addComma = true;
        }
        String src = computeResourceSrc("javascript", script);
        aStr.append( "\"" ).append( org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(src) ).append("\"");
      }
      aStr.append("] }");
      return aStr.toString();
    }
    private String requireCSSCommand() {
      StringBuilder aStr = new StringBuilder("{ \"action\":\"require_css\", \"value\": [");
      boolean addComma = false;
      for(String sheet : this.stylesheets) {
        if(addComma) {
          aStr.append(",");
        } else{
          addComma = true;
        }
        String href = computeResourceSrc("stylesheets", sheet);
        aStr.append( "\"" ).append( org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript(href) ).append("\"");
      }
      aStr.append("] }");
      return aStr.toString();
    }

    //ajax/js runtime request related
    protected abstract void initializeBasics(AbstractPageServlet ps, Object[] args);
    public boolean isServingAsAjaxResponse = false;
    public void serveAsAjaxResponse(Object[] args, TemplateCall templateArg, String placeholderId)
    { 
      AbstractPageServlet ps = ThreadLocalPage.get();
      TemplateServlet ts = ThreadLocalTemplate.get();
      //inherit commandingPage
      commandingPage = ps.commandingPage;
  
      //use passed PageServlet ps here, since this is the context for this type of response
      initializeBasics(ps, args);

      ThreadLocalPage.set(this);
      //outputstream threadlocal is already set, see to-java-servlet/ajax/ajax.str

      this.isServingAsAjaxResponse = true;

      this.placeholderId = placeholderId;
      enterPlaceholderIdContext();
      templateservlet.render(null, args, Environment.createNewLocalEnvironment(envGlobalAndSession), null); // new clean environment with only the global templates, and global/session vars

      ThreadLocalTemplate.set(ts);
      ThreadLocalPage.set(ps);
    }

    protected boolean isTemplate() { return false; }

    public static AbstractPageServlet getRequestedPage(){
        return ThreadLocalPage.get();
    }

    private boolean passedThroughAjaxTemplate = false;
    public boolean passedThroughAjaxTemplate(){
      return passedThroughAjaxTemplate;
    }
    public void setPassedThroughAjaxTemplate(boolean b){
        passedThroughAjaxTemplate = b;
    }

    protected boolean isLogSqlEnabled = false;
    public boolean isLogSqlEnabled() { return isLogSqlEnabled; }

    public boolean isPageCacheDisabled = false;

    protected boolean isOptimizationEnabled = true;
    public boolean isOptimizationEnabled() { return isOptimizationEnabled; }

    public String getExtraQueryArguments(String firstChar) { // firstChar is expected to be ? or &, depending on whether there are more query arguments
      HttpServletRequest req = getRequest();
      return (req != null && req.getQueryString() != null) ? (firstChar + req.getQueryString()) : "";
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
                org.webdsl.logging.Logger.error("MD5 not available: "+ae.getMessage());
                return null;
            }
        }
        return messageDigest;
    }

    public boolean actionToBeExecutedHasDisabledValidation = false;
    public boolean actionHasAjaxPageUpdates = false;
    
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
            return ThreadLocalPage.get().getAbsoluteLocation()+"/"+ThreadLocalPage.get().getActionTarget();
        }
        else{
            //this doesn't work with ajax template render from action, since an ajax template needs to submit to a different page than the original request
            return getRequestURL();
        }
    }

    protected abstract void renderIncomingSuccessMessages();
    protected abstract void renderLogSqlMessage();

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
    public abstract String getUrlQueryParams();
    public abstract String getHiddenPostParamsJson();

    //public javax.servlet.http.HttpSession session;

    public static void cleanupThreadLocals(){
        ThreadLocalEmailContext.set(null);
        ThreadLocalPage.set(null);
        ThreadLocalTemplate.setNull();
    }

    //templates scope
    public static Environment staticEnv = Environment.createSharedEnvironment();

    public Environment envGlobalAndSession = Environment.createLocalEnvironment();

    //emails
    protected static Map<String, Class<?>> emails = new HashMap<String, Class<?>>();
    public static Map<String, Class<?>> getEmails() {
        return emails;
    }
    public boolean sendEmail(String name, Object[] emailargs, Environment emailenv){
        EmailServlet temp = renderEmail(name,emailargs,emailenv);
        return temp.send();
    }
    public EmailServlet renderEmail(String name, Object[] emailargs, Environment emailenv){
        EmailServlet temp = null;
        try
        {
            temp = ((EmailServlet)getEmails().get(name).newInstance());
        }
        catch(IllegalAccessException iae)
        {
            org.webdsl.logging.Logger.error("Problem in email template lookup: " + iae.getMessage());
        }
        catch(InstantiationException ie)
        {
            org.webdsl.logging.Logger.error("Problem in email template lookup: " + ie.getMessage());
        }
        temp.render(emailargs, emailenv);
        return temp;
    }


    //rendertemplate function
    public String renderTemplate(String name, Object[] args, Environment env){
        return executeTemplatePhase(RENDER_PHASE, name, args, env);
    }
    //validatetemplate function
    public String validateTemplate(String name, Object[] args, Environment env){
        return executeTemplatePhase(VALIDATE_PHASE, name, args, env);
    }
    public static final int DATABIND_PHASE = 1;
    public static final int VALIDATE_PHASE = 2;
    public static final int ACTION_PHASE = 3;
    public static final int RENDER_PHASE = 4;
    public String executeTemplatePhase(int phase, String name, Object[] args, Environment env){
        StringWriter s = new StringWriter();
        PrintWriter out = new PrintWriter(s);
        ThreadLocalOut.push(out);
        TemplateServlet enclosingTemplateObject = ThreadLocalTemplate.get();
        try{
            TemplateServlet temp = ((TemplateServlet)env.getTemplate(name).newInstance());
            switch(phase){
                case VALIDATE_PHASE: temp.validateInputs(name, args, env, null); break;
                case RENDER_PHASE:   temp.render(name, args, env, null); break;
            }
        }
        catch(Exception oe){
            try {
                TemplateCall tcall = env.getWithcall(name); //'elements' or requires arg
                TemplateServlet temp = ((TemplateServlet)env.getTemplate(tcall.name).newInstance());
                String parent = env.getWithcall(name)==null?null:env.getWithcall(name).parentName;
                switch(phase){
                    case VALIDATE_PHASE: temp.validateInputs(parent, tcall.args, env, null); break;
                    case RENDER_PHASE:   temp.render(parent, tcall.args, env, null); break;
                }
            }
            catch(Exception ie){
                org.webdsl.logging.Logger.error("EXCEPTION",oe);
                org.webdsl.logging.Logger.error("EXCEPTION",ie);
            }
        }
        ThreadLocalTemplate.set(enclosingTemplateObject);
        ThreadLocalOut.popChecked(out);
        return s.toString();
    }

    //ref arg
    protected static Map<String, Class<?>> refargclasses = new HashMap<String, Class<?>>();
    public static Map<String, Class<?>> getRefArgClasses() {
        return refargclasses;
    }

    public abstract String getAbsoluteLocation();

	public String getXForwardedProto() {
		if (request == null) {
			return null;
		} else {
			return request.getHeader("x-forwarded-proto");
		}
	}

    protected TemplateContext templateContext = new TemplateContext();
    public String getTemplateContextString() {
        return templateContext.getTemplateContextString();
    }
    public void enterPlaceholderIdContext() {
        if( ! "1".equals( placeholderId ) ){
            templateContext.enterTemplateContext( placeholderId );
        }
    }
    public void enterTemplateContext(String s) {
        templateContext.enterTemplateContext(s);
    }
    public void leaveTemplateContext() {
        templateContext.leaveTemplateContext();
    }
    public void leaveTemplateContextChecked(String s) {
        templateContext.leaveTemplateContextChecked(s);
    }
    public void clearTemplateContext(){
        templateContext.clearTemplateContext();
        enterPlaceholderIdContext();
    }
    public void setTemplateContext(TemplateContext tc){
        templateContext = tc;
    }
    public TemplateContext getTemplateContext(){
        return templateContext;
    }

    // objects scheduled to be checked after action completes, filled by hibernate event listener in hibernate util class
    ArrayList<WebDSLEntity> entitiesToBeValidated = new ArrayList<WebDSLEntity>();
    boolean allowAddingEntitiesForValidation = true;

    public void clearEntitiesToBeValidated(){
    	entitiesToBeValidated = new ArrayList<WebDSLEntity>();
        allowAddingEntitiesForValidation = true;
    }

    public void addEntityToBeValidated(WebDSLEntity w){
        if(allowAddingEntitiesForValidation){
        	entitiesToBeValidated.add(w);
        }
    }
    public void validateEntities(){
        allowAddingEntitiesForValidation = false; //adding entities must be disabled when checking is performed, new entities may be loaded for checks, but do not have to be checked themselves

        java.util.Set<WebDSLEntity> set = new java.util.HashSet<WebDSLEntity>(entitiesToBeValidated);
        java.util.List<utils.ValidationException> exceptions = new java.util.LinkedList<utils.ValidationException>();
        for(WebDSLEntity w : set){

            if(w.isChanged()){
                try {
    //              System.out.println("validating: "+ w.get_WebDslEntityType() + ":" + w.getName());
                    w.validateSave();
                  //System.out.println("done validating");
                } catch(utils.ValidationException ve){
                    exceptions.add(ve);
                } catch(utils.MultipleValidationExceptions ve) {
                    for(utils.ValidationException vex : ve.getValidationExceptions()){
                        exceptions.add(vex);
                    }
                }
            }
        }

        if(exceptions.size() > 0){
            throw new utils.MultipleValidationExceptions(exceptions);
        }
        clearEntitiesToBeValidated();
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
    
    public boolean shouldReInitializeTemplates = false;

    protected java.util.List<String> javascripts = new java.util.ArrayList<String>();
    protected java.util.List<String> tailJavascripts = new java.util.ArrayList<String>();
    protected java.util.List<String> stylesheets = new java.util.ArrayList<String>();
    protected java.util.List<String> bodyAttributes = new java.util.ArrayList<String>();

    protected java.util.Map<String,String> customHeadNoDuplicates = new java.util.HashMap<String,String>();

    public void addJavascriptInclude(String filename) { commandingPage.addJavascriptIncludeInternal( filename ); }
    public void addJavascriptIncludeInternal(String filename) {
        if(!javascripts.contains(filename))
            javascripts.add(filename);
    }
    public void addJavascriptTailInclude(String filename) { commandingPage.addJavascriptTailIncludeInternal( filename ); }
    public void addJavascriptTailIncludeInternal(String filename) {
        if(!tailJavascripts.contains(filename))
        	tailJavascripts.add(filename);
    }
    public void addStylesheetInclude(String filename) { commandingPage.addStylesheetIncludeInternal( filename ); }
    public void addStylesheetIncludeInternal(String filename) {
        if(!stylesheets.contains(filename)){
            stylesheets.add(filename);
        }
    }
    public void addStylesheetInclude(String filename, String media) { commandingPage.addStylesheetIncludeInternal( filename, media ); }
    public void addStylesheetIncludeInternal(String filename, String media) {
    	String combined = media != null && !media.isEmpty() ? filename + "\" media=\""+ media : filename;
        if(!stylesheets.contains(combined)){
            stylesheets.add(combined);
        }
    }

    public void addCustomHead(String header) { commandingPage.addCustomHeadInternal(header, header); }
    public void addCustomHead(String key, String header) { commandingPage.addCustomHeadInternal(key, header); }
    public void addCustomHeadInternal(String key, String header) {
        customHeadNoDuplicates.put(key, header);
    }
    
    public void addBodyAttribute(String key, String value) { commandingPage.addBodyAttributeInternal(key, value); }
    public void addBodyAttributeInternal(String key, String value) {
    	bodyAttributes.add(" "+key+"=\""+value+"\"");
    }

    protected abstract void initialize();
    protected abstract void conversion();
    protected abstract void loadArguments();
    public abstract void initVarsAndArgs();

    public void clearHibernateCache() {
        // used to be only ' hibSession.clear(); ' but that doesn't revert already flushed changes.
        // since flushing now happens automatically when querying, this could produce wrong results.
        // e.g. output in page with validation errors shows changes that were not persisted to the db.
        // see regression test in test/succeed-web/validate-false-and-flush.app
        utils.HibernateUtil.getCurrentSession().getTransaction().rollback();

        /* http://community.jboss.org/wiki/sessionsandtransactions
         * Because Hibernate can't bind the "current session" to a transaction, as it does in a JTA environment,
         * it binds it to the current Java thread. It is opened when getCurrentSession() is called for the first
         * time, but in a "proxied" state that doesn't allow you to do anything except start a transaction. When
         * the transaction ends, either through commit or roll back, the "current" Session is closed automatically.
         * The next call to getCurrentSession() starts a new proxied Session, and so on. In other words,
         * the session is bound to the thread behind the scenes, but scoped to a transaction, just like in a JTA environment.
         */
        openNewTransactionThroughGetCurrentSession();
        ThreadLocalServlet.get().reloadSessionManager(hibernateSession);
        initVarsAndArgs();
        hibernateCacheCleared = true;
    }

    protected org.hibernate.Session openNewTransactionThroughGetCurrentSession(){
    	hibernateSession = utils.HibernateUtil.getCurrentSession();
    	hibernateSession.beginTransaction();
    	return hibernateSession;
    }

    protected HttpServletRequest request;
    protected ResponseWrapper response;
    protected HttpServletResponse httpServletResponse;
    protected Object[] args;

//    public void setHibSession(Session s) {
//        hibSession = s;
//    }
//
//    public Session getHibSession() {
//        return hibSession;
//    }

    public HttpServletRequest getRequest() {
        return request;
    }
    private String requestURLCached = null;
    private String requestURICached = null; 
    public String getRequestURL(){
      if(requestURLCached == null) {
        requestURLCached = AbstractDispatchServletHelper.get().getRequestURL();
      }
      return requestURLCached;
    }
    public String getRequestURI(){
      if(requestURICached == null) {
        requestURICached = AbstractDispatchServletHelper.get().getRequestURI();
      }
      return requestURICached;
    }

    public ResponseWrapper getResponse() {
        return response;
    }
    public void addResponseHeader(String key, String value) {
      if( response != null ) {
        response.setHeader(key, value);
      }
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
    protected boolean validateFailedBeforeRollback = false;
    public boolean isRollback() {
        return rollback;
    }
    public void setRollback() {
        validateFailedBeforeRollback = this.isNotValid();
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

    // used for runtime check to detect nested forms
    protected String inForm = null;
    public boolean isInForm() {
    	return inForm != null;
    }
    public void enterForm(String t) {
    	inForm = t;
    }
    public String getEnclosingForm() {
    	return inForm;
    }
    public void leaveForm() {
    	inForm = null;
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

    protected Map<String,List<utils.File>> fileUploads;
    public Map<String, List<utils.File>> getFileUploads() {
        return fileUploads;
    }
    public List<utils.File> getFileUploads(String key) {
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
    public boolean isRedirected(){
      return !"".equals(redirectUrl);
    }
    public String getRedirectUrl() {
        return redirectUrl;
    }
    public void setRedirectUrl(String a) {
        this.redirectUrl = a;
    }
    // perform the actual redirect
    public void redirect(){
      try {  response.sendRedirect(this.getRedirectUrl()); }
      catch (IOException ioe) { org.webdsl.logging.Logger.error("redirect failed", ioe); }
    }


    protected String mimetype = "text/html; charset=UTF-8";
    protected boolean mimetypeChanged = false;
    public String getMimetype() {
        return mimetype;
    }
    public void setMimetype(String mimetype) {
        this.mimetype = mimetype;
        mimetypeChanged = true;
        if(!isMarkupLangMimeType.matcher(mimetype).find()){
        	enableRawoutput();
        }
        disableTemplateSpans();
    }

    protected boolean downloadInline = false;


    public boolean getDownloadInline() {
        return downloadInline;
    }

    public void enableDownloadInline() {
        this.downloadInline = true;
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

    protected List<String> reRenderPlaceholders = null;
    protected Map<String,String> reRenderPlaceholdersContent = null;
    public boolean isReRenderPlaceholders() {
        return reRenderPlaceholders != null;
    }
    public void addReRenderPlaceholders(String placeholder) {
        if(reRenderPlaceholders == null){
            reRenderPlaceholders = new ArrayList<String>();
            reRenderPlaceholdersContent = new HashMap<String,String>();
        }
        reRenderPlaceholders.add(placeholder);
    }
    public void addReRenderPlaceholdersContent(String placeholder, String content) {
        if(reRenderPlaceholders != null && reRenderPlaceholders.contains(placeholder)){
            reRenderPlaceholdersContent.put(placeholder,content);
        }
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
            if(!downloadInline) {
                response.setHeader("Content-Disposition", "attachment; filename=\"" + download.getFileNameForDownload() + "\"");
            }
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
            org.webdsl.logging.Logger.error("exception in download serve", ex);
        }
        catch (IOException ex) {
            if(ex.getClass().getName().equals("org.apache.catalina.connector.ClientAbortException")) {
              org.webdsl.logging.Logger.error( "ClientAbortException - " + ex.getMessage() );
            } else {
              org.webdsl.logging.Logger.error("exception in download serve",ex);
            }
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
      //session manager
      public void reloadSessionManagerFromExistingSessionId(UUID sessionId){
    	  ThreadLocalServlet.get().reloadSessionManagerFromExistingSessionId(hibernateSession, sessionId);
    	  initialize(); //reload session variables
      }

      //request vars

      public HashMap<String, Object> requestScopedVariables = new HashMap<String, Object>();

      public void initRequestVars(){
        initRequestVars(null);
      }

      public abstract void initRequestVars(PrintWriter out);

      protected long startTime = 0L;

      public long getStartTime() {
          return startTime;
      }

      public long getElapsedTime() {
          return System.currentTimeMillis() - startTime;
      }
      
      public Object getRequestScopedVar(String key){
        return commandingPage.requestScopedVariables.get(key);
      }

      public void addRequestScopedVar(String key, Object val){
    	  if(val != null){
              commandingPage.requestScopedVariables.put(key, val);
    	  }
      }

      public void addRequestScopedVar(String key, WebDSLEntity val){
    	  if(val != null){
              val.setRequestVar();
              commandingPage.requestScopedVariables.put(key, val);
    	  }
      }
      // statistics to be shown in log
      protected abstract void increaseStatReadOnly();
      protected abstract void increaseStatReadOnlyFromCache();
      protected abstract void increaseStatUpdate();
      protected abstract void increaseStatActionFail();
      protected abstract void increaseStatActionReadOnly();
      protected abstract void increaseStatActionUpdate();

      // register whether entity changes were made, see isChanged property of entities
      protected boolean hasWrites = false;
      
      public void setHasWrites(boolean b){
    	  commandingPage.hasWrites = b;
      }

      protected void updatePageRequestStatistics(){
    	  if(hasNotExecutedAction()){
    		  if(!hasWrites || isRollback()){
    			  if(pageCacheWasUsed){
    				  increaseStatReadOnlyFromCache();
    			  }
    			  else{
    				  increaseStatReadOnly();
    			  }
    		  }
    		  else{
    			  increaseStatUpdate();
    		  }
    	  }
    	  else{
    		  if(isNotValid()){
    			  increaseStatActionFail();
    		  }
    		  else{
    			  if(!hasWrites || isRollback()){
    				  increaseStatActionReadOnly();
    			  }
    			  else{
    				  increaseStatActionUpdate();
    			  }
    		  }
    	  }
      }
      
      // Hibernate interceptor hooks (such as beforeTransactionCompletion) catch Throwable but then only log the error, e.g. when db transaction conflict occurs
      // this causes the problem that a page might be rendered with data that was not actually committed
      // workaround: store the exception in this variable and explicitly rethrow before sending page content to output stream
      public Exception exceptionInHibernateInterceptor = null;

	public static Environment loadTemplateMap(Class<?> clazz) {
		return loadTemplateMap(clazz, null, staticEnv);
	}
	public static Environment loadTemplateMap(Class<?> clazz, String keyOverwrite, Environment env) {
		reflectionLoadClassesHelper(clazz, "loadTemplateMap", new Object[] { keyOverwrite, env });
		return env;
 	}
	public static Object[] loadEmailAndTemplateMapArgs = new Object[] { staticEnv, emails };
	public static void loadEmailAndTemplateMap(Class<?> clazz) {
		reflectionLoadClassesHelper(clazz, "loadEmailAndTemplateMap", loadEmailAndTemplateMapArgs);
	}
	public static Object[] loadLiftedTemplateMapArgs = new Object[] { staticEnv };
	public static void loadLiftedTemplateMap(Class<?> clazz) {
		reflectionLoadClassesHelper(clazz, "loadLiftedTemplateMap", loadLiftedTemplateMapArgs);
	}
	public static Object[] loadRefArgClassesArgs = new Object[] { refargclasses };
	public static void loadRefArgClasses(Class<?> clazz) {
		reflectionLoadClassesHelper(clazz, "loadRefArgClasses", loadRefArgClassesArgs);
	}
	public static void reflectionLoadClassesHelper(Class<?> clazz, String method, Object[] args) {
		for (java.lang.reflect.Method m : clazz.getMethods()) {
			if (method.equals(m.getName())) {  // will just skip if not defined, so the code generator does not need to generate empty methods
				try {
					m.invoke(null, args);
				} catch (IllegalAccessException | IllegalArgumentException | java.lang.reflect.InvocationTargetException e) {
					e.printStackTrace();
				}
				break;
			}
		}
	}

}
