package org.webdsl.lang;

import java.util.List;

public class ReflectionProperty<E,P>{

    public ReflectionProperty(String name, boolean notnull, String format){
        this.name = name;
        this.hasNotNullAnnotation = notnull;
        this.formatAnnotation = format;
    }
    
    private String name;
    public String getName(){
      return name;      
    }
    
    private String formatAnnotation;
    public String getFormatAnnotation(){
        return formatAnnotation;
    }
    
    private boolean hasNotNullAnnotation = false;
    public boolean hasNotNullAnnotation(){
      return hasNotNullAnnotation;
    }
    
    public List<P> getAllowed(E arg){
      System.out.println("Internal error: getAllowed method of ReflectionProperty for "+name+ " should have been overridden.");
      return null;
    }
    
}