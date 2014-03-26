package org.webdsl.lang;

import java.util.HashMap;
import java.util.Map;

public class EnvironmentTemplateGlobalLookup implements IEnvironmentTemplateLookup{

	protected Map<String,Class<?>> templates = new HashMap<String,Class<?>>();

	public EnvironmentTemplateGlobalLookup(){}

	public Class<?> getTemplate(String key) {
		if (templates != null && templates.containsKey(key)){
			return templates.get(key);
		}
		else{
			throw new RuntimeException("template lookup failed for name: "+key);   
		}
	}

	public IEnvironmentTemplateLookup putTemplate(String key, Class<?> value) {
		templates.put(key, value);
		return this;
	}

}
