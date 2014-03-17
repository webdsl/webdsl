package utils;

import java.util.Collections;
import java.util.List;
import java.util.Set;

public class CollectionType {
    
    public static <T, S extends T> List<T> addAll(List<T> list, List<S> toAdd){
      list.addAll(toAdd);
      return list;
    }
    public static <T, S extends T> List<T> addAll(List<T> list, Set<S> toAdd){
    	list.addAll(toAdd);
    	return list;
    }
    public static <T, S extends T> Set<T> addAll(Set<T> list, List<S> toAdd){
    	list.addAll(toAdd);
    	return list;
    }
    public static <T, S extends T> Set<T> addAll(Set<T> list, Set<S> toAdd){
    	list.addAll(toAdd);
    	return list;
    }
    
    // utility method to create a list with elements in a single expression
	public static <T> List<T> addAll(List<T> c, T... elements){
		Collections.addAll(c, elements);
		return c;
	}
    
}
