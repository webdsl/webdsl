package utils;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class CollectionType {

	public static <T, S extends T> List<T> addAll(List<T> list, List<S> toAdd) {
		list.addAll(toAdd);
		return list;
	}

	public static <T, S extends T> List<T> addAll(List<T> list, Set<S> toAdd) {
		list.addAll(toAdd);
		return list;
	}

	public static <T, S extends T> Set<T> addAll(Set<T> list, List<S> toAdd) {
		list.addAll(toAdd);
		return list;
	}

	public static <T, S extends T> Set<T> addAll(Set<T> list, Set<S> toAdd) {
		list.addAll(toAdd);
		return list;
	}

	// utility method to create a list with elements in a single expression
	public static <T> List<T> addAll(List<T> c, T... elements) {
		Collections.addAll(c, elements);
		return c;
	}

	public static <T> T get(Collection<T> c, int index) {
		if (index >= 0 && index < c.size()) {
			int i = 0;
			for (T e : c) {
				if (i == index) {
					return e;
				}
				i++;
			}
		} else {
			utils.Warning.errorWithSmallStackTrace("get(" + index + ") out of bounds (set size is " + c.size() + ")", 5, 2);
		}
		return null;
	}

	public static <T> T getFirst(Collection<T> c) {
		Iterator<T> iterator = c.iterator();
		if (iterator.hasNext()) {
			return iterator.next();
		} else {
			utils.Warning.errorWithSmallStackTrace("collection.first has no result because collection is empty", 5, 2);
		}
		return null;
	}

	public static <T> T getLast(Collection<T> c) {
		T result = null;
		if (c.size() > 0) {
			for (T e : c) {
				result = e;
			}
		} else {
			utils.Warning.errorWithSmallStackTrace("collection.last has no result because collection is empty", 5, 2);
		}
		return result;
	}

}
