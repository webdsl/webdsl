package org.webdsl.querylist;

import java.util.Iterator;
import java.util.List;

public interface QueryList<T extends Comparable> {

	public abstract void addFilter(Filter filter);

	public abstract List<T> list();

	public abstract void add(T o);

	public abstract boolean contains(T o);

	public abstract T get(int index);

	public abstract Iterator<T> iterator();

	public abstract boolean remove(T o);

	public abstract int size();

	public abstract Object[] toArray();

}