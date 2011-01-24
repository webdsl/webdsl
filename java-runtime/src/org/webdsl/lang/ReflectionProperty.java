package org.webdsl.lang;

public class ReflectionProperty{

    public ReflectionProperty(String name, boolean notnull){
        this.name = name;
        this.hasNotNullAnnotation = notnull;
    }
    
    private String name;
    public String getName(){
      return name;      
    }
    
    private boolean hasNotNullAnnotation = false;
    public boolean hasNotNullAnnotation(){
      return hasNotNullAnnotation;
    }
    
}