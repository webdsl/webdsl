package utils;

import java.util.HashMap;
import java.util.Map;

public abstract class AbstractAttributeCollection {

	protected Map<String,String> attrsmap = new HashMap<String,String>();

	public abstract void init();
	public abstract String getAttributes();
	public abstract String getClassAttribute();
	public abstract String getStyleAttribute();

}
