package org.webdsl.lang;

import java.util.HashMap;
import java.util.Map;

/**
 *  lookup of global variables
 */
public class EnvironmentGlobalVariableLookup {

	protected Map<String,Object> variables = new HashMap<String,Object>();

	public EnvironmentGlobalVariableLookup(){}

	public Object getVariable(String key) {
		Object o = variables.get(key);
		if(o != null){
			return o;
		}
		else{
			throw new RuntimeException("global variable lookup failed for name: "+key);   
		}
	}

	public void putVariable(String key, Object value) {
		variables.put(key, value);
	}

}
