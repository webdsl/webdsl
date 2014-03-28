package org.webdsl.lang;

import utils.AbstractPageServlet;
import utils.LocalTemplateArguments;
import utils.ThreadLocalPage;
import utils.ThreadLocalTemplate;

public class Environment {

	public static Environment createSharedEnvironment(){
		return new Environment(null,null,new EnvironmentTemplateGlobalLookup(), null, new EnvironmentVariableLookup());
	}

	public static Environment createLocalEnvironment(){
		return new Environment(AbstractPageServlet.staticEnv
				, new EnvironmentWithCallLookup(null)
				, new EnvironmentTemplateLocalLookup(AbstractPageServlet.staticEnv.templates)
				, new EnvironmentExtraLocalTemplateArgs(null)
				, AbstractPageServlet.staticEnv.variables);
	}

	public Environment(Environment up, EnvironmentWithCallLookup withCalls, IEnvironmentTemplateLookup templates, 
			EnvironmentExtraLocalTemplateArgs extra, EnvironmentVariableLookup variables)
	{
		this.withCalls = withCalls;
		this.templates = templates;
		this.variables = variables;
		this.extraLocalTemplateArguments = extra;
	}

	public Environment(Environment up)
	{
		withCalls = up.withCalls;
		this.templates = up.templates;
		this.variables = up.variables;
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
	
	public utils.TemplateCall getWithcall(String key) {
		return withCalls.getWithcall(key);
	}

	public Environment putWithcall(String key, utils.TemplateCall value) {
		withCalls = withCalls.putWithcall(key, value);
		return this; // enable chaining for convenient code generation
	}
	
	protected EnvironmentVariableLookup variables = null;
	
	public Object getVariable(String key) {
		return variables.getVariable(key);
	}

	public void putVariable(String key, Object value) {
		variables.putVariable(key, value);
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
