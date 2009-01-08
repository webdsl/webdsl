package utils;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.ArrayList;


public class ScopedMap<T> {

    private ArrayList<Map<String, T>> scopes = new ArrayList<Map<String,T>>();
    
    private Map<String, T> getCurrentMap()
    {
        return scopes.get(scopes.size() -1);    	
    }
    
    public ScopedMap()
    {
        enterScope();  
    }
    
    public ScopedMap<T> enterScope()
    {
        scopes.add(new HashMap<String, T>());
        return this;
    }	
    
    public void leaveScope()
    {
        if (scopes.size() <= 1)
            throw new RuntimeException("It is not allowed to remove the base scope");
        scopes.remove(scopes.size() -1);        
    }

    public T get(Object key) {
        for(int i = scopes.size() -1; i >= 0; i--)
            if (scopes.get(i).containsKey(key))
                return scopes.get(i).get(key);
        throw new RuntimeException("Value with key '"+key+"' not found!");
    }

    public void put(String key, T value) {
        getCurrentMap().put(key, value);
    }

}
