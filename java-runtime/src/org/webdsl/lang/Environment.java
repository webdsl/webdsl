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
            return up.getTemplate(key);
        }
    }

    public void putTemplate(String key, Class value) {
        if(templates == null){
            templates = new HashMap<String,Class>();
        }
        templates.put(key, value);
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
