package org.webdsl.querylist;

import java.util.ArrayList;

public class ParameterBindings {
	private ArrayList<Object> bindings = new ArrayList<Object>();
	public int add(Object o) {
		bindings.add(o);
		return bindings.size()-1;
	}
}
