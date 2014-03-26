package org.webdsl.lang;

public interface IEnvironmentTemplateLookup {
	
	public Class<?> getTemplate(String key);
	public IEnvironmentTemplateLookup putTemplate(String key, Class<?> value);

}
