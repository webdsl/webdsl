package org.webdsl.lang;

public class ReflectionProperty{

    public ReflectionProperty(String name, boolean notnull, String format, boolean searchable){
        this.name = name;
        this.hasNotNullAnnotation = notnull;
        this.formatAnnotation = format;
        this.hasSearchableAnnotation = searchable;
    }
    
    private String name;
    public String getName(){
      return name;      
    }
    
    private String formatAnnotation;
    public String getFormatAnnotation(){
        return formatAnnotation;
    }
    
    private boolean hasSearchableAnnotation = false;
    public boolean hasSearchableAnnotation(){
    	return hasSearchableAnnotation;
    }
    
    private boolean hasNotNullAnnotation = false;
    public boolean hasNotNullAnnotation(){
      return hasNotNullAnnotation;
    }
    
}