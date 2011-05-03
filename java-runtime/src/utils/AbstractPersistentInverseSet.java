package utils;

import org.hibernate.collection.PersistentSet;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.persister.collection.CollectionPersister;

@SuppressWarnings({ "unchecked", "serial" })
public abstract class AbstractPersistentInverseSet extends PersistentSet {
	protected boolean initializing = false;
	protected utils.OwnedSet tempSet = null;

	public AbstractPersistentInverseSet(SessionImplementor session) {
		super(session);
	}

	public AbstractPersistentInverseSet(SessionImplementor session, java.util.Set set) {
		super(session, set);
	}

	public abstract utils.OwnedSet newOwnedSetFromCollectionEntry(org.hibernate.engine.CollectionEntry entry);
	// x_entclass owner = (x_entclass) utils.HibernateUtilConfigured.getSessionFactory().getCurrentSession().load(x_entclass.class, entry.getLoadedKey());
	// return new x_entclass#x_prop#Set(owner);

	@Override
	public void beforeInitialize(CollectionPersister persister, int anticipatedSize) {
		super.beforeInitialize(persister, anticipatedSize);
		//System.out.println("Set::beforeInitialize(" + (getOwner() == null ? "null" : "owner")  + ")");
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(getOwner());
			//System.out.println("Passed Onto Set");
		}
	}

	@Override
	public void beginRead() {
		initializing = true;
		((utils.OwnedSet)set).setUpdateInverse(false);
		super.beginRead();
	}

	@Override
	public boolean endRead() {
		initializing = false;
		afterInitialize();
		boolean result = super.endRead();
		((utils.OwnedSet)set).setUpdateInverse(true);
		return result;
	}

	@Override
	public boolean add(Object value) {
		if(value == null) {
			return false;
		}

		//dirty();
		//if(wasInitialized() || initializing) {
			
			return super.add(value);
		/*}
		else {
			if(tempSet == null) {
				org.hibernate.engine.CollectionEntry entry = getSession().getPersistenceContext().getCollectionEntry(this);
				tempSet = newOwnedSetFromCollectionEntry(entry);
			}
			if(tempSet.add(value)) {
				queueOperation( new SimpleAdd(value) );
				return true;
			}
			return false;
		}*/
	}

	@Override
	public boolean remove(Object value) {
		if(value == null) {
			return false;
		}

		return super.remove(value);
	}

	@Override
	public void setOwner(Object owner) {
		//System.out.println("Set::setOwner(" + (owner == null ? "null" : "owner")  + ")");
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(owner);
			//System.out.println("Passed Onto Set");
		}
		super.setOwner(owner);
	}

	/*final class SimpleAdd implements DelayedOperation {
		private Object value;
		
		public SimpleAdd(Object value) {
			this.value = value;
		}
		public void operate() {
			((utils.OwnedSet)set).setUpdateInverse(false);
			set.add(value);
			((utils.OwnedSet)set).setUpdateInverse(true);
		}
		public Object getAddedInstance() {
			return value;
		}
		public Object getOrphan() {
			return null;
		}
	}*/
}