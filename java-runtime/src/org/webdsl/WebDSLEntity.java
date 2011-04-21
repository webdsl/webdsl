package org.webdsl;

import java.io.Serializable;
import java.util.List;

/*
 * The T type argument is a workaround to allow return types of the implementation
 * of functions like all_() to be more specific than List<WebDSLEntity>.
 */

@SuppressWarnings("rawtypes")
public interface WebDSLEntity<T extends WebDSLEntity> extends Serializable {
    boolean isInstance(Class<?> c);
    public boolean instanceOf(String s);
    public Object getId();
    public String get_WebDslEntityType();
    public java.lang.Integer getVersion(); 
    public void setVersion(java.lang.Integer i); 
    public String getName();
    public void validateSave();
    public boolean isChanged();
    public List<T> all_();
}
