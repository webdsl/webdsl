package org.webdsl;

import java.io.Serializable;
import java.util.List;
import java.util.UUID;
public interface WebDSLEntity extends Serializable {
    boolean isInstance(Class<?> c);
    public boolean instanceOf(String s);
    public UUID getId();
    public WebDSLEntity setId(UUID o);
    public String get_WebDslEntityType();
    public java.lang.Integer getVersion(); 
    public WebDSLEntity setVersion(java.lang.Integer i);
    public java.util.Date getCreated();
    public WebDSLEntity setCreated(java.util.Date d);
    public java.util.Date getModified();
    public WebDSLEntity setModified(java.util.Date d);
    public String getName();
    public void validateSave();
    public boolean isChanged();
    public List<?> all_();
    public boolean removeUninitializedLazyProperty(String name);
    public void setRequestVar();
    public boolean isRequestVar();
}
