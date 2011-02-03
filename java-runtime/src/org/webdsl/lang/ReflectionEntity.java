package org.webdsl.lang;

import java.util.ArrayList;
import java.util.List;

public class ReflectionEntity{

    public ReflectionEntity(String name){
        this.name = name;
    }
    private String name;
    public String getName(){
      return name;      
    }
    
    private List<ReflectionProperty> properties = new ArrayList<ReflectionProperty>();
    public List<ReflectionProperty> getProperties(){
        return properties;
    }
    
    public ReflectionProperty getPropertyByName(String name){
        for(ReflectionProperty p: properties){
            if(p.getName().equals(name)){
                return p;
            }
        }
        System.out.println("reflection property not found: "+name);
        return null; 
    }
}
