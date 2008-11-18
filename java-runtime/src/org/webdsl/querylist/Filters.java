package org.webdsl.querylist;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

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
				return getObjectFromProperty(o, property).equals(value);
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
				return !getObjectFromProperty(o, property).equals(value);
			}
		};
	}
	
	private static String propertyNameToHibernateProperty(String property) {
		return "_" + property.replace(".", "._");
	}

	private static Object getObjectFromProperty(Object o, String property) {
		String[] parts = property.split("\\.");
		try {
			for (String prop : parts) {
				Method m = o.getClass().getMethod(
						"get" + Character.toUpperCase(prop.charAt(0))
								+ prop.substring(1));
				o = m.invoke(o);
			}
			return o;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
