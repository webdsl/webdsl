package org.webdsl.querylist;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class MemoryQueryList<T extends Comparable> implements QueryList<T> {
	protected ArrayList<T> lst = new ArrayList<T>();
	protected ArrayList<Filter> filters = new ArrayList<Filter>();

	public MemoryQueryList() {

	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#addFilter(org.webdsl.querylist.Filter)
	 */
	public void addFilter(Filter filter) {
		filters.add(filter);
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#list()
	 */
	public List<T> list() {
		ArrayList<T> result = new ArrayList<T>(lst.size());
		outterfor: for (T item : lst) {
			for (Filter f : filters) {
				if (!f.matches(item)) {
					continue outterfor;
				}
			}
			result.add(item);
		}
		return result;
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#add(T)
	 */
	public void add(T o) {
		lst.add(o);
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#contains(T)
	 */
	public boolean contains(T o) {
		return lst.contains(o);
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#get(int)
	 */
	public T get(int index) {
		return lst.get(index);
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#iterator()
	 */
	public Iterator<T> iterator() {
		return lst.iterator();
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#remove(T)
	 */
	public boolean remove(T o) {
		return lst.remove(o);
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#size()
	 */
	public int size() {
		return lst.size();
	}

	/* (non-Javadoc)
	 * @see org.webdsl.querylist.QueryList#toArray()
	 */
	public Object[] toArray() {
		return lst.toArray();
	}
}
