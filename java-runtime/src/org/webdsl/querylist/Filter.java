package org.webdsl.querylist;

import java.util.List;
import java.util.Map;

public interface Filter {
	boolean matches(Comparable<Object> o);
	String toHQL(List<Object> bindings);
}
