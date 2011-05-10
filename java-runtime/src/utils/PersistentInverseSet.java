package utils;

import org.hibernate.collection.PersistentSet;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.persister.collection.CollectionPersister;

@SuppressWarnings({ "unchecked", "serial" })
public class PersistentInverseSet extends PersistentSet {
	protected boolean initializing = false;
	protected utils.OwnedSet tempSet = null;

	public PersistentInverseSet(SessionImplementor session) {
		super(session);
	}

	public PersistentInverseSet(SessionImplementor session, java.util.Set set) {
		super(session, set);
	}

	@Override
	public void beforeInitialize(CollectionPersister persister, int anticipatedSize) {
		super.beforeInitialize(persister, anticipatedSize);

		// The super method just initialized the set, so we need to pass on the owner
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(getOwner());
		}
	}

	@Override
	public void beginRead() {
		initializing = true;
		((utils.OwnedSet)set).setUpdateInverse(false); // This prevents inverse updates while initializing
		super.beginRead();
	}

	@Override
	public boolean endRead() {
		initializing = false;
		//afterInitialize(); // Needed for DelayedOperations
		boolean result = super.endRead();
		((utils.OwnedSet)set).setUpdateInverse(true); // We should resume updating the inverse, because initialization is complete
		return result;
	}

	@Override
	public boolean add(Object value) {
		if(value == null) {
			return false;
		}

		// The code in this method is commented out, because it only works for Many-to-one inverse sets.
		// It allows adding to the set without initializing
		// You also need the SimpleAdd class below and the afterInitialize() call above
		// The reason this does not work for Many-to-many sets and lists in general is because inserts on the join table are not performed

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
		if(set != null && set instanceof utils.OwnedSet) {
			((utils.OwnedSet)set).setOwner(owner);
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