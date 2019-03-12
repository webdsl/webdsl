package utils;

import org.hibernate.StaleObjectStateException;

public class TemplateAction{

	//TODO: get rid of getElementsContext() calls in action code, then this field is no longer needed     
	String elementsContext = null;

	public String getElementsContext(){
		return elementsContext;
	}

	public void handleAction(AbstractPageServlet threadLocalPageCached, org.webdsl.lang.Environment env, String elementsContext, String actionident, TemplateActionBody body){
		this.elementsContext = elementsContext;
		if (!threadLocalPageCached.hasExecutedAction){
			threadLocalPageCached.hasExecutedAction = true;
			try{
				body.run();

				// trigger data invariant validations
				utils.HibernateUtil.getCurrentSession().flush();
				if(!threadLocalPageCached.isRollback()){
					threadLocalPageCached.validateEntities();
				}
			}
			catch(utils.ValidationException ve){
				threadLocalPageCached.getValidationExceptions().add(ve.setName(actionident));
				threadLocalPageCached.setValidated(false);
			}
			catch(utils.MultipleValidationExceptions ve){
				for(utils.ValidationException vex : ve.getValidationExceptions()){
					threadLocalPageCached.getValidationExceptions().add(vex.setName(actionident));
				}
				threadLocalPageCached.setValidated(false);
			}
			catch(Exception excep){
			  AbstractDispatchServletHelper servlet = ThreadLocalServlet.get();
			  if(excep instanceof StaleObjectStateException && servlet.retries < AbstractDispatchServletHelper.maxRetries){
			    //In case a stale object state exception is thrown during handling of action, re-throw the exception, so DispatchPageServlet.handlePage() will retry handling this request. 
			    throw excep;
			  } else {
			    org.webdsl.logging.Logger.error("exception during execution of action", excep);
	        threadLocalPageCached.getValidationExceptions().add(new utils.ValidationException(actionident,"An error occurred while processing your request"));
	        threadLocalPageCached.setValidated(false);
			  }
				
			}
			finally{
				// do the redirect if no exceptions occurred and no validations failed
				if(threadLocalPageCached.isRedirected() && threadLocalPageCached.isValid()){
					if(threadLocalPageCached.isAjaxRuntimeRequest()){  // only important thing for redirects is the current request type (through ajax.js or regular form submit),
							                                           // to determine whether to do a response.sendRedirect or a command for ajax.js (relocate)
						// it was an action submit through ajax.js runtime
						ThreadLocalOut.peek().print("{ action: \"relocate\", value: \""+threadLocalPageCached.getRedirectUrl()+"\" },\n");
					}
					else{
						// regular submit button form submit
						try{
							threadLocalPageCached.getResponse().sendRedirect(threadLocalPageCached.getRedirectUrl());
						} 
						catch(java.io.IOException ioe){ 
							org.webdsl.logging.Logger.error("redirect failed", ioe);
						}
					}
				}
				// redirect to current page by default
				if(!threadLocalPageCached.isRedirected() && !threadLocalPageCached.isDownloadSet() && threadLocalPageCached.isValid()){
					try{
						if(!threadLocalPageCached.isAjaxActionExecuted()){
							threadLocalPageCached.setRedirectUrl(threadLocalPageCached.getPageUrlWithParams() + threadLocalPageCached.getExtraQueryAruments("?"));
							if(!threadLocalPageCached.isActionLinkUsed()){ 
								threadLocalPageCached.getResponse().sendRedirect(threadLocalPageCached.getRedirectUrl());
							}
						}
						if(!threadLocalPageCached.actionHasAjaxPageUpdates){
							ThreadLocalOut.peek().print("{ action: \"refresh\" },");
						}
					}
					catch(java.io.IOException ioe){
						org.webdsl.logging.Logger.error("redirect failed", ioe);
					}
				}
			}
		}
	}
}
