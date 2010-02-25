package utils;

import java.util.*;

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
    
}
