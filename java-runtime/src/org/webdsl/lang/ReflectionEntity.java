package org.webdsl.lang;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("rawtypes")
public class ReflectionEntity{

    public ReflectionEntity(String name, String superename, boolean hasViewPage){
        this.name = name;
        this.hasViewPage = hasViewPage;
        this.superename = superename;
    }
    
    private String name;
    public String getName(){
      return name;      
    }
    
    private String superename;
    private ReflectionEntity supere;
    // initialize the first time it is requested, that way the order in which
    // these classes are initially created doesn't matter
    public ReflectionEntity getSuper(){
        if(superename == null){
            return null;
        }
        else{
            if(supere != null){
                return supere;
            }
            else{
                supere = byName(superename);
                return (supere);
            }
        }
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
        ReflectionProperty tmp = null;
        if(getSuper() != null && (tmp = getSuper().getPropertyByName(name)) != null){
            return tmp;
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
