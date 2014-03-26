package org.webdsl.lang;

public class EnvironmentTemplateLocalLookup implements IEnvironmentTemplateLookup {

	protected IEnvironmentTemplateLookup up = null;
	protected String name = null;
	protected Class<?> template = null;

	public EnvironmentTemplateLocalLookup(IEnvironmentTemplateLookup up)
	{
		this.up = up;
	}

	public Class<?> getTemplate(String key) {
		if (key.equals(name)){
			return template;
		}
		else{
			if(up!=null){
				return up.getTemplate(key);
			}
			else{
				throw new RuntimeException("template lookup failed for name: "+key);   
			}
		}
	}

	public EnvironmentTemplateLocalLookup putTemplate(String key, Class<?> value) {
		name = key;
		template = value;
		return new EnvironmentTemplateLocalLookup(this);
	}

}
