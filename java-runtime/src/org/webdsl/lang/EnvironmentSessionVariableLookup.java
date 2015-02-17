package org.webdsl.lang;

import java.util.HashMap;
import java.util.Map;

import org.webdsl.logging.Logger;

/**
 *  lookup of session variables
 */
public class EnvironmentSessionVariableLookup {

	protected Map<String,Object> variables = new HashMap<String,Object>();

	public EnvironmentSessionVariableLookup(){}

	public Object getVariable(String key) {
		Object o = variables.get(key);
		if(o == null){
			Logger.error(new RuntimeException("session variable lookup failed for name: "+key));
		}
		return o;
	}

	public void putVariable(String key, Object value) {
		variables.put(key, value);
	}

}
