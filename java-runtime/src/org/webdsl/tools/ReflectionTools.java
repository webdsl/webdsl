package org.webdsl.tools;

import java.lang.reflect.*;

public class ReflectionTools {
  public static Object getProperty(Object o, String property) {
    String[] parts = property.split("\\.");
    try {
      for (String prop : parts) {
        Method m = o.getClass().getMethod("get" + Character.toUpperCase(prop.charAt(0)) + prop.substring(1));
        o = m.invoke(o);
      }
      return o;
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  public static void setProperty(Object o, String property, Object value) {
    String[] parts = property.split("\\.");
    try {
      for (String prop : parts) {
        if(prop == parts[parts.length-1]) {
          Method m = o.getClass().getMethod("set" + Character.toUpperCase(prop.charAt(0)) + prop.substring(1));
          m.invoke(o, value);
        } else {
          Method m = o.getClass().getMethod("get" + Character.toUpperCase(prop.charAt(0)) + prop.substring(1));
          o = m.invoke(o);
        }
      }
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }
}
