package org.webdsl.lang;

public class ReflectionProperty{

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
    
}