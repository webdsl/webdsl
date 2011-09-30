package org.webdsl;

import java.io.Serializable;
import java.util.List;
import java.util.UUID;
public interface WebDSLEntity extends Serializable {
    boolean isInstance(Class<?> c);
    public boolean instanceOf(String s);
    public UUID getId();
    public void setId(UUID o);
    public String get_WebDslEntityType();
    public java.lang.Integer getVersion(); 
    public void setVersion(java.lang.Integer i); 
    public String getName();
    public void validateSave();
    public boolean isChanged();
    public List<?> all_();
}
