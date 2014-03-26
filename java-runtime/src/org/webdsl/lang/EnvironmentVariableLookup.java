package org.webdsl.lang;

import java.util.HashMap;
import java.util.Map;

/**
 *  lookup of global and session variables
 */
public class EnvironmentVariableLookup {

	protected Map<String,Object> variables = new HashMap<String,Object>();

	public EnvironmentVariableLookup(){}

	public Object getVariable(String key) {
		Object o = variables.get(key);
		if(o != null){
			return o;
		}
		else{
			throw new RuntimeException("global/session variable lookup failed for name: "+key);   
		}
	}

	public void putVariable(String key, Object value) {
		variables.put(key, value);
	}

}
