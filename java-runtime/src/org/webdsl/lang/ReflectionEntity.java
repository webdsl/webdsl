package org.webdsl.lang;

import java.util.ArrayList;
import java.util.List;

public class ReflectionEntity{

    public ReflectionEntity(String name, boolean hasViewPage){
        this.name = name;
        this.hasViewPage = hasViewPage;
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
    
    private boolean hasViewPage = false;
    public boolean hasViewPage(){
      return hasViewPage;      
    }
    
    private static ArrayList<ReflectionEntity> entities = new ArrayList<ReflectionEntity>(); 
    
    public static void add(ReflectionEntity e){
        entities.add(e);
    }
    
    public List<ReflectionEntity> all(){
        return entities;
    }
    
    public static ReflectionEntity byName(String s){
        for(ReflectionEntity e : entities){
            if(e.getName().equals(s)){
                return e;
            }
        }
        return null;
    }
}
