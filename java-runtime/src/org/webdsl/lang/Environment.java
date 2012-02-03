package org.webdsl.lang;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import utils.LocalTemplateArguments;

public class Environment {

    private Environment up = null;
    
    public Environment(Environment up)
    {
        this.up = up;
    }
    
    public Environment(){}
    
    
    
    private Map<String,Class> templates = null;

    public Map<String,Class> getTemplates(){
        return templates;
    }
    
    public Class getTemplate(String key) {
        if (templates != null && templates.containsKey(key)){
            return templates.get(key);
        }
        else{
            if(up != null){
                return up.getTemplate(key);
            }
            else{
                throw new RuntimeException("template lookup failed for name: "+key);   
            }
        }
    }

    public void putTemplate(String key, Class value) {
        if(templates == null){
            templates = new HashMap<String,Class>();
        }
        templates.put(key, value);
    }

    public boolean isRedefinedTemplate(String key) {
        if (templates != null && templates.containsKey(key)){
            return up != null;
        }
        else{
            if(up != null){
                return up.isRedefinedTemplate(key);
            }
            else{
                throw new RuntimeException("template lookup failed for name: "+key);   
            }
        }
    }
    
    /**
     *  'with/requires' calls map
        
          define page root(){
            var i := 7
            test() with {
              ---> content(s:String){ "123" output(s) output(i) } <---
            }
          }
          define test() requires content(String){
            "content: " content("456")
          }
          
          content(s:String) is lifted, i becomes an argument, 
          a partial templatecall is stored in the environment
          which contains the name of the lifted template and the value of i 
          
          returns null if templatecall is not found, used when 'elements' are empty
     */
    protected Map<String, utils.TemplateCall> withcallsmap = null;
    
    public Map<String, utils.TemplateCall> getWithcallsmap(){ return withcallsmap; }
    
    public utils.TemplateCall getWithcall(String key) {
        if (withcallsmap != null && withcallsmap.containsKey(key)){
            return withcallsmap.get(key);
        }
        else{
            if(up!=null){
                return up.getWithcall(key);
            }
            else{
                return null;
            }
        }
    }

    public void putWithcall(String key, utils.TemplateCall value) {
        if(withcallsmap == null){
            withcallsmap = new HashMap<String,utils.TemplateCall>();
        }
        withcallsmap.put(key, value);
    }
    
    
    /**
     *  Was used for storing vars for passing them on to local template redefinitions, this is no longer the case.
     *  TODO: Still used for globals and sessions, although if that is the only usage, they don't have to be in this Environment class.
     */
    private Map<String,Object> variables = null;
   
    public Map<String,Object> getVariables(){
        return variables;
    }

    public Object getVariable(String key) {
        if (variables != null && variables.containsKey(key)){
            return variables.get(key);
        }
        else{
            return up.getVariable(key);
        }
    }

    public void putVariable(String key, Object value) {
        if(variables == null){
             variables = new HashMap<String,Object>();
        }
        variables.put(key, value);
    }

    
    /**
     * Used for storing implicit arguments to local template redefinitions
     * 
          define page root() {
            var st := "1"
            form{
              b(12345)  	
              submit action{ } {"save"}
            } 
            define b(i:Int) = a(*,--->st<---)
          }
          define a(i:Int, s:Ref<String>){}
          define b(i:Int){}
     * 
     */
    private Map<String,LocalTemplateArguments> extraLocalTemplateArguments = null;
    
    public Map<String,LocalTemplateArguments> getExtraLocalTemplateArguments(){
        return extraLocalTemplateArguments;
    }

    public LocalTemplateArguments getExtraLocalTemplateArguments(String key) {
        if (extraLocalTemplateArguments != null && extraLocalTemplateArguments.containsKey(key)){
            return extraLocalTemplateArguments.get(key);
        }
        else if(up != null){
            return up.getExtraLocalTemplateArguments(key);
        }
        else{
            return null;
        }
    }

    public void putExtraLocalTemplateArguments(String key, LocalTemplateArguments value) {
        if(extraLocalTemplateArguments == null){
            extraLocalTemplateArguments = new HashMap<String,LocalTemplateArguments>();
        }
        extraLocalTemplateArguments.put(key, value);
    }    
    
}
