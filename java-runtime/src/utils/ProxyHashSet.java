package utils;

import java.util.*;
import org.webdsl.WebDSLEntity;
import org.hibernate.proxy.HibernateProxy;

// An alternative version of java.util.HashSet that does not initialize hibernate proxies
public class ProxyHashSet<E extends WebDSLEntity>
    extends AbstractSet<E>
    implements Set<E>, Cloneable
{
    private transient HashMap<UUID,E> map;

    /**
     * Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
     * default initial capacity (16) and load factor (0.75).
     */
    public ProxyHashSet() {
        map = new HashMap<UUID,E>();
    }

    /**
     * Constructs a new set containing the elements in the specified
     * collection.  The <tt>HashMap</tt> is created with default load factor
     * (0.75) and an initial capacity sufficient to contain the elements in
     * the specified collection.
     *
     * @param c the collection whose elements are to be placed into this set
     * @throws NullPointerException if the specified collection is null
     */
    public ProxyHashSet(Collection<? extends E> c) {
        map = new HashMap<UUID,E>(Math.max((int) (c.size()/.75f) + 1, 16));
        addAll(c);
    }

    /**
     * Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
     * the specified initial capacity and the specified load factor.
     *
     * @param      initialCapacity   the initial capacity of the hash map
     * @param      loadFactor        the load factor of the hash map
     * @throws     IllegalArgumentException if the initial capacity is less
     *             than zero, or if the load factor is nonpositive
     */
    public ProxyHashSet(int initialCapacity, float loadFactor) {
        map = new HashMap<UUID,E>(initialCapacity, loadFactor);
    }

    /**
     * Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
     * the specified initial capacity and default load factor (0.75).
     *
     * @param      initialCapacity   the initial capacity of the hash table
     * @throws     IllegalArgumentException if the initial capacity is less
     *             than zero
     */
    public ProxyHashSet(int initialCapacity) {
        map = new HashMap<UUID,E>(initialCapacity);
    }

    /**
     * Returns an iterator over the elements in this set.  The elements
     * are returned in no particular order.
     *
     * @return an Iterator over the elements in this set
     * @see ConcurrentModificationException
     */
    public Iterator<E> iterator() {
        return map.values().iterator();
    }

    /**
     * Returns the number of elements in this set (its cardinality).
     *
     * @return the number of elements in this set (its cardinality)
     */
    public int size() {
        return map.size();
    }

    /**
     * Returns <tt>true</tt> if this set contains no elements.
     *
     * @return <tt>true</tt> if this set contains no elements
     */
    public boolean isEmpty() {
        return map.isEmpty();
    }

    /**
     * Returns <tt>true</tt> if this set contains the specified element.
     * More formally, returns <tt>true</tt> if and only if this set
     * contains an element <tt>e</tt> such that
     * <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
     *
     * @param o element whose presence in this set is to be tested
     * @return <tt>true</tt> if this set contains the specified element
     */
    public boolean contains(Object o) {
    	if(o instanceof WebDSLEntity) {
    		if(o instanceof HibernateProxy) {
    			return map.containsKey((UUID)((HibernateProxy)o).getHibernateLazyInitializer().getIdentifier());
    		}
    		else {
    			return map.containsKey(((WebDSLEntity)o).getId());
    		}
    	} else {
    		return false;
    	}
    }

    /**
     * Adds the specified element to this set if it is not already present.
     * More formally, adds the specified element <tt>e</tt> to this set if
     * this set contains no element <tt>e2</tt> such that
     * <tt>(e==null&nbsp;?&nbsp;e2==null&nbsp;:&nbsp;e.equals(e2))</tt>.
     * If this set already contains the element, the call leaves the set
     * unchanged and returns <tt>false</tt>.
     *
     * @param e element to be added to this set
     * @return <tt>true</tt> if this set did not already contain the specified
     * element
     */
    @Override
    public boolean add(E e) {
    	if(e == null) { // Can't call getId on null, so always return false
    		return false;
    	}
    	else if(e instanceof HibernateProxy) {
			return map.put((UUID)((HibernateProxy)e).getHibernateLazyInitializer().getIdentifier(), e) == null;
		}
		else {
			return map.put(e.getId(), e)==null;
		}
    }

    /**
     * Removes the specified element from this set if it is present.
     * More formally, removes an element <tt>e</tt> such that
     * <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>,
     * if this set contains such an element.  Returns <tt>true</tt> if
     * this set contained the element (or equivalently, if this set
     * changed as a result of the call).  (This set will not contain the
     * element once the call returns.)
     *
     * @param o object to be removed from this set, if present
     * @return <tt>true</tt> if the set contained the specified element
     */
    public boolean remove(Object o) {
    	if(o == null) { // Can't call getId on null, so always return false
    		return false;
    	}
    	else if(o instanceof WebDSLEntity) {
    		if(o instanceof HibernateProxy) {
    			return map.remove((UUID)((HibernateProxy)o).getHibernateLazyInitializer().getIdentifier()) != null;
    		}
    		else {
    			return map.remove(((WebDSLEntity)o).getId()) != null;
    		}
    	} else {
    		return false;
    	}
    }

    /**
     * Removes all of the elements from this set.
     * The set will be empty after this call returns.
     */
    public void clear() {
        map.clear();
    }

    /**
     * Returns a shallow copy of this <tt>HashSet</tt> instance: the elements
     * themselves are not cloned.
     *
     * @return a shallow copy of this set
     */
    @SuppressWarnings("unchecked")
	public Object clone() {
        try {
            ProxyHashSet<E> newSet = (ProxyHashSet<E>) super.clone();
            newSet.map = (HashMap<UUID, E>) map.clone();
            return newSet;
        } catch (CloneNotSupportedException e) {
            throw new InternalError();
        }
    }
}