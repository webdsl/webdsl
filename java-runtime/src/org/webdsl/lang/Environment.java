package org.webdsl.lang;

import utils.AbstractPageServlet;
import utils.LocalTemplateArguments;
import utils.ThreadLocalPage;
import utils.ThreadLocalTemplate;

public class Environment {

	public static Environment createSharedEnvironment(){
		return new Environment(null,null,new EnvironmentTemplateGlobalLookup(), null, null, null);
	}

	public static Environment createLocalEnvironment(){
		return new Environment(AbstractPageServlet.staticEnv
				, new EnvironmentWithCallLookup(null)
				, new EnvironmentTemplateLocalLookup(AbstractPageServlet.staticEnv.templates)
				, new EnvironmentExtraLocalTemplateArgs(null)
				, new EnvironmentGlobalVariableLookup()
				, new EnvironmentSessionVariableLookup());
	}
	
	// new environment with references to shared global template lookup, and global and session variables of current local environment
	public static Environment createNewLocalEnvironment(Environment envGlobalAndSession){
		return new Environment(AbstractPageServlet.staticEnv
				, new EnvironmentWithCallLookup(null)
				, new EnvironmentTemplateLocalLookup(AbstractPageServlet.staticEnv.templates)
				, new EnvironmentExtraLocalTemplateArgs(null)
				, envGlobalAndSession.globalVariables
				, envGlobalAndSession.sessionVariables);
	}

	public Environment(Environment up, EnvironmentWithCallLookup withCalls, IEnvironmentTemplateLookup templates, 
			EnvironmentExtraLocalTemplateArgs extra, EnvironmentGlobalVariableLookup globalVariables, EnvironmentSessionVariableLookup sessionVariables)
	{
		this.withCalls = withCalls;
		this.templates = templates;
		this.globalVariables = globalVariables;
		this.sessionVariables = sessionVariables;
		this.extraLocalTemplateArguments = extra;
	}

	public Environment(Environment up)
	{
		withCalls = up.withCalls;
		this.templates = up.templates;
		this.globalVariables = up.globalVariables;
		this.sessionVariables = up.sessionVariables;
		this.extraLocalTemplateArguments = up.extraLocalTemplateArguments;
	}

	protected IEnvironmentTemplateLookup templates = null;

	public Class<?> getTemplate(String key) {
		return templates.getTemplate(key);
	}

	public void putTemplate(String key, Class<?> value) {
		templates = templates.putTemplate(key, value);
	}

	protected EnvironmentWithCallLookup withCalls = null;
	
	//When elements cannot be found, return the dummy EmptyElementsCall
	//This might happen when a template call, that had no elements in its call, is optimized, but the template definition does expect elements
	public utils.TemplateCall getElementscall(String key){
	  if(key == utils.TemplateCall.SkipElementsMarker) {
	    return utils.TemplateCall.EmptyElementsCall;
	  } else {
	    utils.TemplateCall tc = getWithcall(key);
	    return tc != null ? tc : utils.TemplateCall.EmptyElementsCall;
	  }
	}
	
	public utils.TemplateCall getWithcall(String key) {
		return withCalls.getWithcall(key);
	}

	public Environment putWithcall(String key, utils.TemplateCall value) {
		withCalls = withCalls.putWithcall(key, value);
		return this; // enable chaining for convenient code generation
	}
	
	protected EnvironmentGlobalVariableLookup globalVariables = null;
	
	public Object getGlobalVariable(String key) {
		return globalVariables.getVariable(key);
	}

	public void putGlobalVariable(String key, Object value) {
		globalVariables.putVariable(key, value);
	}

	protected EnvironmentSessionVariableLookup sessionVariables = null;
	
	public Object getSessionVariable(String key) {
		return sessionVariables.getVariable(key);
	}

	public void putSessionVariable(String key, Object value) {
		sessionVariables.putVariable(key, value);
	}	
	
	protected EnvironmentExtraLocalTemplateArgs extraLocalTemplateArguments = null;

	public LocalTemplateArguments getExtraLocalTemplateArguments(String key) {
		return extraLocalTemplateArguments.getExtraLocalTemplateArguments(key);
	}

	public Object[] addExtraLocalTemplateArgumentsToArguments(Object[] args, String key) {
		return extraLocalTemplateArguments.addExtraLocalTemplateArgumentsToArguments(args, key);
	}

	public void putExtraLocalTemplateArguments(String key, LocalTemplateArguments value) {
		extraLocalTemplateArguments = extraLocalTemplateArguments.putExtraLocalTemplateArguments(key, value);
	}  

	/**
	 * Utility for expression translation, to retrieve either a new env from the action/template context (if available, 
	 * which is the case when the expression is used inside an action/template), or from the global env (expression used inside a function).
	 * @return {@link Environment}
	 */
	public static Environment getLocalOrGlobalEnv(){
		Environment result = ThreadLocalTemplate.getEnv();
		if(result == null){
			result = ThreadLocalPage.getEnv();
		}
		return new Environment(result);
	}

}
