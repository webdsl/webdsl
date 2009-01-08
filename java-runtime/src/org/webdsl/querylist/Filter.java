package org.webdsl.querylist;

import java.util.List;

public interface Filter {
	boolean matches(Comparable<Object> o);
	String toHQL(List<Object> bindings);
}
