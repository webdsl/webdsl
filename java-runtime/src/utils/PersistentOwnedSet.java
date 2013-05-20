package utils;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Iterator;

import org.hibernate.collection.PersistentSet;
import org.hibernate.engine.LoadQueryInfluencers;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.impl.FilterImpl;
import org.hibernate.persister.collection.CollectionPersister;
import org.hibernate.type.CustomCollectionType;

@SuppressWarnings({ "unchecked", "serial" })
public class PersistentOwnedSet extends PersistentSet implements utils.PersistentOwnedCollection {
	protected int cachedSize = -1;
    protected org.hibernate.impl.FilterImpl filter = null;
    protected org.hibernate.impl.FilterImpl filterHint = null;
    protected utils.AbastractOwnedSetType cachedType = null;
    protected org.hibernate.impl.FilterImpl restoreFilter = null;

	public PersistentOwnedSet(SessionImplementor session) {
		super(session);
	}

	public PersistentOwnedSet(SessionImplementor session, java.util.Set set) {
		super(session, set);
	}

	@Override
	public void beforeInitialize(CollectionPersister persister, int anticipatedSize) {
		super.beforeInitialize(persister, anticipatedSize);
		/*java.util.Set<java.util.Map.Entry<String, org.hibernate.impl.FilterImpl>> e = this.getSession().getLoadQueryInfluencers().getEnabledFilters().entrySet();
		for(java.util.Map.Entry<String, org.hibernate.impl.FilterImpl> f : e) {
			String params = "";
			for(Object p : f.getValue().getParameters().values()) {
				if(!"".equals(params)) params += ",";
				params += p;
			}
			try{org.webdsl.logging.Logger.info("enabled: " + f.getKey() + "(" + params + ")");}catch(Exception e2){org.webdsl.logging.Logger.error("EXCEPTION",e2);}
		}
		try{throw new Exception("beforeInitialize");}catch(Exception e){org.webdsl.logging.Logger.error("EXCEPTION",e);}*/
		// The super method just initialized the set, so we need to pass on the owner
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(getOwner());
		}
	}

	@Override
	public void beginRead() {
		setFilter(getAffectingFilter());
		
		/*java.util.Set<java.util.Map.Entry<String, org.hibernate.impl.FilterImpl>> e = this.getSession().getLoadQueryInfluencers().getEnabledFilters().entrySet();
		for(java.util.Map.Entry<String, org.hibernate.impl.FilterImpl> f : e) {
			String params = "";
			for(Object p : f.getValue().getParameters().values()) {
				if(!"".equals(params)) params += ",";
				params += p;
			}
			try{org.webdsl.logging.Logger.info("enabled: " + f.getKey() + "(" + params + ")");}catch(Exception e2){org.webdsl.logging.Logger.error("EXCEPTION",e2);}
		}
		try{throw new Exception("beginRead");}catch(Exception e){org.webdsl.logging.Logger.error("EXCEPTION",e);}*/
		((utils.OwnedSet)set).setDoEvents(false); // This prevents events, like inverse updates, while initializing
		super.beginRead();
	}

	@Override
	public boolean endRead() {
		//afterInitialize(); // Needed for DelayedOperations
		boolean result = super.endRead();
		((utils.OwnedSet)set).setDoEvents(true); // We should resume updating the inverse, because initialization is complete

		if(this.restoreFilter != null) {
			// Restore the filter that was enabled before enabling the filter hint
			SessionImplementor session = getSession();
			org.hibernate.engine.LoadQueryInfluencers lqi = session.getLoadQueryInfluencers();
			org.hibernate.impl.FilterImpl oldFilter = this.getAffectingFilter();
			if(oldFilter != null) lqi.disableFilter(oldFilter.getName());
			utils.QueryOptimization.restoreFilter(lqi, this.restoreFilter);
			this.restoreFilter = null;
		}

		return result;
	}

	@Override
	public boolean add(Object value) {
		if(value == null) {
			return false;
		}

		correctFilter(true);
		return super.add(value);
	}

	@Override
	public boolean remove(Object value) {
		if(value == null) {
			return false;
		}
		
		correctFilter(true);
		return super.remove(value);
	}

	@Override
	public void setOwner(Object owner) {
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(owner);
		}
		super.setOwner(owner);
	}

	@Override
	public void initializeFromCache(CollectionPersister persister, Serializable disassembled, Object owner)
	throws org.hibernate.HibernateException {
		Serializable[] array = ( Serializable[] ) disassembled;
		int size = array.length;
		beforeInitialize( persister, size );
		((utils.OwnedSet)set).setDoEvents(false);
		for (int i = 0; i < size; i++ ) {
			Object element = persister.getElementType().assemble( array[i], getSession(), owner );
			if ( element != null ) {
				set.add( element );
			}
		}
		((utils.OwnedSet)set).setDoEvents(true);
	}

	@Override
	protected int getCachedSize() {
		if(cachedSize == -1) return super.getCachedSize();
		return cachedSize;
	}

	@Override
	public boolean afterInitialize() {
		cachedSize = -1;
		return super.afterInitialize();
	}

	@Override
	public void postAction() {
		super.postAction();
		cachedSize = -1;
	}

	protected void throwLazyInitializationExceptionIfNotConnected() {
		SessionImplementor session = getSession();
		if ( !(session!=null && session.isOpen() && session.getPersistenceContext().containsCollection(this)) )  {
			throwLazyInitializationException("no session or session was closed");
		}
		if ( !session.isConnected() ) {
            throwLazyInitializationException("session is disconnected");
		}		
	}
	
	protected void throwLazyInitializationException(String message) {
		throw new org.hibernate.LazyInitializationException(
				"failed to lazily initialize a collection" + 
				( getRole()==null ?  "" : " of role: " + getRole() ) + 
				", " + message
			);
	}

	// Ideally this should be implemented by overriding the initialize(boolean), read(), write(), dirty() methods of AbstractPersistentCollection
	// However, these methods are declared final. So instead we override all methods that call them and include a call to correctFilter(boolean) or 
	// unfiltered(boolean). These methods ensure that the correct filtering is used, for example, that no filter has been applied to dirty collections,
	// because then filtered elements would be removed from the collection permanently after a flush/commit.
	public void correctFilter(boolean writing) {
		if(writing) {
			unfiltered(writing);
		} else if(!wasInitialized() && getFilterHint() != null) { // implies getFilter() == null, because !wasInitialized()
			// Use the filter hint if it is less restrictive than the requested filter
			// In that case the filter hint warns about the future use of a different filter that requires re-fetching
			utils.AbastractOwnedSetType type = getOwnedSetType();
			FilterImpl newFilter = getAffectingFilter(type);
			FilterImpl hintFilter = getFilterHint();
			if(newFilter != null && !utils.QueryOptimization.equalFilters(hintFilter, newFilter) && type.isFilterCompatible(hintFilter, newFilter)) {
				this.restoreFilter = newFilter;
				SessionImplementor session = getSession();
				org.hibernate.engine.LoadQueryInfluencers lqi = session.getLoadQueryInfluencers();
				lqi.disableFilter(newFilter.getName());
				utils.QueryOptimization.restoreFilter(lqi, hintFilter);
			}
		} else if(wasInitialized() && getFilter() != null) { // Only need to check the filter if the collection was initialized using a filter
			utils.AbastractOwnedSetType type = getOwnedSetType();
			FilterImpl oldFilter = getFilter();
			FilterImpl newFilter = getAffectingFilter(type);
			if(!type.isFilterCompatible(oldFilter, newFilter)) unfiltered(writing);
		}
	}
	public void unfiltered(boolean writing) {
		if(wasInitialized() && getFilter() == null) return; // The collection was already initialized without filters
		if(wasInitialized()) { // Cleaning the filtered collection
			try{
				Field f = org.hibernate.collection.AbstractPersistentCollection.class.getDeclaredField("initialized");
				f.setAccessible(true);
				f.setBoolean(this, Boolean.FALSE);
				set = null;
			}catch(Exception e) {
				org.webdsl.logging.Logger.error("EXCEPTION",e);
			}
		}
		SessionImplementor session = getSession();

		// Disable the affecting filter
		FilterImpl oldFilter = getAffectingFilter();
		if(oldFilter != null) {
			session.getLoadQueryInfluencers().disableFilter(oldFilter.getName());
		}

		// Initialize the collection
		initialize(writing);
		session.initializeCollection(this, writing);

		// Enable the affecting filter again
		if(oldFilter != null) {
			utils.QueryOptimization.restoreFilter(session.getLoadQueryInfluencers(), oldFilter);
		}
		if(writing) dirty();
	}

    public org.hibernate.impl.FilterImpl getFilter() {
    	return this.filter;
    }

    public void setFilter(org.hibernate.impl.FilterImpl filter) {
    	this.filter = filter;
    	this.filterHint = null; // 
    }

    public org.hibernate.impl.FilterImpl getFilterHint() {
    	return this.filterHint;
    }

    public void setFilterHint(org.hibernate.impl.FilterImpl filterHint) {
    	this.filterHint = filterHint;
    }

	public utils.AbastractOwnedSetType getOwnedSetType() {
		if(cachedType != null) {
			return cachedType;
		}
		else {
			SessionImplementor session = getSession();
			CollectionPersister persister = session.getPersistenceContext().getCollectionEntry(this).getLoadedPersister();
			if(persister.getCollectionType() instanceof CustomCollectionType && ((CustomCollectionType)persister.getCollectionType()).getUserType() instanceof utils.AbastractOwnedSetType) {
				cachedType = (utils.AbastractOwnedSetType)((CustomCollectionType)persister.getCollectionType()).getUserType();
				return cachedType;
			}
			return null;
		}
	}

    protected FilterImpl getAffectingFilter() {
    	return getAffectingFilter(getOwnedSetType());
	}

	protected FilterImpl getAffectingFilter(utils.AbastractOwnedSetType type) {
		SessionImplementor session = getSession();
		FilterImpl filter = null;
		LoadQueryInfluencers lqi = session.getLoadQueryInfluencers();
		if(lqi != null) {
			java.util.Map filters = lqi.getEnabledFilters();
			for(Object entry : filters.entrySet()) {
				if(!(entry instanceof java.util.Map.Entry)) continue;
				Object key = ((java.util.Map.Entry)entry).getKey();
				Object value = ((java.util.Map.Entry)entry).getValue();
				if(key != null && value != null && value instanceof org.hibernate.impl.FilterImpl && type.isAffectedBy(key.toString())) {
					if(filter == null) {
						filter = (org.hibernate.impl.FilterImpl) value;
					} else {
						throw new java.lang.UnsupportedOperationException("Filters '" + filter.getName() + "' and '" + key.toString() + "' both filter the same collection role" + (getRole() == null ? "." : " (" + getRole() + ")."));
					}
				}
			}
		}
		return filter;
	}

	@Override
	public Iterator iterator() {
		correctFilter(false);
		read();
		return new IteratorProxy(set.iterator());
	}

	@Override
	public Object[] toArray() {
		correctFilter(false);
		return super.toArray();
	}

	@Override
	public Object[] toArray(Object[] array) {
		correctFilter(false);
		return super.toArray(array);
	}

	@Override
	public boolean addAll(Collection coll) {
		if ( coll.size() > 0 ) {
			correctFilter(true);
			return super.addAll(coll);
		}
		return false;
	}

	@Override
	public boolean retainAll(Collection coll) {
		correctFilter(true);
		return super.retainAll(coll);
	}

	@Override
	public boolean removeAll(Collection coll) {
		if ( coll.size() > 0 ) {
			correctFilter(true);
			return super.removeAll(coll);
		}
		return false;
	}

	@Override
	public void clear() {
		correctFilter(true);
		super.clear();
	}

	// The following methods always force unfiltered initialization, because they have different semantics if performed on a filtered collection.
	// For example, existence checks and size operations.

	@Override
	public boolean containsAll(Collection coll) {
		unfiltered(false);
		return super.containsAll(coll);
	}

	@Override
	public boolean equals(Object other) {
		unfiltered(false);
		return super.equals(other);
	}

	@Override
	public int hashCode() {
		unfiltered(false);
		return super.hashCode();
	}

	@Override
	public String toString() {
		unfiltered(false);
		return super.toString();
	}

	@Override
	protected Boolean readIndexExistence(Object index) {
		unfiltered(false);
		read();
		return super.readIndexExistence(index);
	}

	@Override
	protected Boolean readElementExistence(Object element) {
		unfiltered(false);
		read();
		return super.readElementExistence(element);
	}

	// From AbstractPErsistentCollection, but without extra-lazy check
	@Override
	protected boolean readSize() {
		if (!wasInitialized()) {
			if ( cachedSize!=-1 && !hasQueuedOperations() ) {
				return true;
			}
			else {
				// Can be worse for: if(set.length > 0) { "set:" output(set) }
				/*throwLazyInitializationExceptionIfNotConnected();
				SessionImplementor session = getSession();
				org.hibernate.engine.CollectionEntry entry = session.getPersistenceContext().getCollectionEntry(this);
				CollectionPersister persister = entry.getLoadedPersister();
				//if ( persister.isExtraLazy() ) {
				if ( hasQueuedOperations() ) {
					session.flush();
				}
				cachedSize = persister.getSize( entry.getLoadedKey(), session );
				return true;*/
				//}
			}
		}
		unfiltered(false);
		read();
		return false;
	}

	@Override
	protected Object readElementByIndex(Object index) {
		unfiltered(false);
		read();
		return super.readElementByIndex(index);
	}

	final class IteratorProxy implements Iterator {
		private final Iterator iter;
		IteratorProxy(Iterator iter) {
			this.iter=iter;
		}
		public boolean hasNext() {
			return iter.hasNext();
		}

		public Object next() {
			return iter.next();
		}

		public void remove() {
			correctFilter(true);
			write();
			iter.remove();
		}
	}
}