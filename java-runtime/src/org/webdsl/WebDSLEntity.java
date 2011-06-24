package org.webdsl;

import java.io.Serializable;
import java.util.List;

@org.hibernate.search.annotations.FullTextFilterDefs({@org.hibernate.search.annotations.FullTextFilterDef(name = "fieldConstraintFilter", impl = org.webdsl.search.FieldConstraintFilter.class)})
public interface WebDSLEntity extends Serializable {
    boolean isInstance(Class<?> c);
    public boolean instanceOf(String s);
    public Object getId();
    public String get_WebDslEntityType();
    public java.lang.Integer getVersion(); 
    public void setVersion(java.lang.Integer i); 
    public String getName();
    public void validateSave();
    public boolean isChanged();
    public List<?> all_();
}
