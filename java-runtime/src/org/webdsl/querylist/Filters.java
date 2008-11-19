package org.webdsl.querylist;

import java.util.List;
import org.webdsl.tools.*;

public class Filters {
	public static Filter and(final Filter f1, final Filter f2) {
		return new Filter() {
			@Override
			public String toHQL(List<Object> bindings) {
				return "(" + f1.toHQL(bindings) + ") and (" + f2.toHQL(bindings) + ")";
			}

			@Override
			public boolean matches(Comparable<Object> o) {
				return f1.matches(o) && f2.matches(o);
			}
		};
	}

	public static Filter or(final Filter f1, final Filter f2) {
		return new Filter() {
			@Override
			public String toHQL(List<Object> bindings) {
				return "(" + f1.toHQL(bindings) + ") or (" + f2.toHQL(bindings) + ")";
			}

			@Override
			public boolean matches(Comparable<Object> o) {
				return f1.matches(o) || f2.matches(o);
			}
		};
	}

	public static Filter eq(final String property, final Object value) {
		return new Filter() {
			@Override
			public String toHQL(List<Object> bindings) {
				bindings.add(value);
				return "item." + propertyNameToHibernateProperty(property) + " = ?";
			}

			@Override
			public boolean matches(Comparable<Object> o) {
				return ReflectionTools.getProperty(o, property).equals(value);
			}
		};
	}

	public static Filter neq(final String property, final Object value) {
		return new Filter() {
			@Override
			public String toHQL(List<Object> bindings) {
				bindings.add(value);
				return "item." + propertyNameToHibernateProperty(property) + " <> ?";
			}

			@Override
			public boolean matches(Comparable<Object> o) {
				return !ReflectionTools.getProperty(o, property).equals(value);
			}
		};
	}
	
	private static String propertyNameToHibernateProperty(String property) {
		return "_" + property.replace(".", "._");
	}
}
