package org.webdsl;

import java.io.Serializable;

public interface WebDSLEntity extends Serializable {
    boolean isInstance(Class<?> c);
    public boolean instanceOf(String s);
    public Object getId();
    public String get_WebDslEntityType();
}
