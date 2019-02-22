package utils;

public abstract class RefArg{
	
	public abstract Object set(Object obj);

	public abstract Object get();

	public java.util.List<Object> getAllowed(){
		return null;
	}

	// the following are only overridden for ref arg referring to an entity property, template variable ref arg uses these defaults
	
	public void load(String uuid){}

	public org.webdsl.WebDSLEntity getEntity(){
		return null;
	}

	public String get_WebDslEntityType(){
		return "not supported for this type of reference argument (refers to template variable)";
	}

	public String getUrlString(){
		return "not supported for this type of reference argument (refers to template variable)";
	}

	public void validate(String location, java.util.List<utils.ValidationException> exceptions){}

	public java.util.List<String> getValidationErrors(){
		return new java.util.ArrayList<String>();
	}

	@SuppressWarnings("rawtypes")
	public org.webdsl.lang.ReflectionProperty getReflectionProperty(){
		return null;
	}
	
}