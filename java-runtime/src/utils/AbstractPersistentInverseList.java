package utils;

import org.hibernate.collection.PersistentList;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.persister.collection.CollectionPersister;

@SuppressWarnings({ "unchecked", "serial" })
public abstract class AbstractPersistentInverseList extends PersistentList {
	protected boolean initializing = false;
	protected utils.OwnedList tempList = null;

	public AbstractPersistentInverseList(SessionImplementor session) {
		super(session);
	}

	public AbstractPersistentInverseList(SessionImplementor session, java.util.List list) {
		super(session, list);
	}

	public abstract utils.OwnedList newOwnedListFromCollectionEntry(org.hibernate.engine.CollectionEntry entry);
	// x_entclass owner = (x_entclass) utils.HibernateUtilConfigured.getSessionFactory().getCurrentSession().load(x_entclass.class, entry.getLoadedKey());
	// return new x_entclass#x_prop#Set(owner);

	@Override
	public void beforeInitialize(CollectionPersister persister, int anticipatedSize) {
		super.beforeInitialize(persister, anticipatedSize);
		//System.out.println("List::beforeInitialize(" + (getOwner() == null ? "null" : "owner")  + ")");
		if(list != null && list instanceof utils.OwnedList) {
			((utils.OwnedList)list).setOwner(getOwner());
			//System.out.println("Passed Onto List");
		}
	}

	@Override
	public void beginRead() {
		initializing = true;
		((utils.OwnedList)list).setUpdateInverse(false);
		super.beginRead();
	}

	@Override
	public boolean endRead() {
		initializing = false;
		//afterInitialize(); // Not needed for lists, because this is already called by a super class
		boolean result = super.endRead();
		((utils.OwnedList)list).setUpdateInverse(true);
		return result;
	}

	@Override
	public boolean add(Object value) {
		if(value == null) {
			return false;
		}

		//if(wasInitialized() || initializing) {
			//if(initializing) ((utils.OwnedList)list).setUpdateInverse(false);
			boolean result = super.add(value);
			//if(initializing) ((utils.OwnedList)list).setUpdateInverse(true);
			return result;
			/*}
		else {
			dirty();
			if(tempList == null) {
				org.hibernate.engine.CollectionEntry entry = getSession().getPersistenceContext().getCollectionEntry(this);
				tempList = newOwnedListFromCollectionEntry(entry);
			}
			if(tempList.add(value)) {
				queueOperation( new SimpleAdd(value) );
				return true;
			}
			return false;
		}*/
	}

	@Override
	public void add(int index, Object value) {
		if(value == null || index < 0 || index > size()) {
			return;
		}

		//if(wasInitialized() || initializing) {
			//if(initializing) ((utils.OwnedList)list).setUpdateInverse(false);
			super.add(value);
			//if(initializing) ((utils.OwnedList)list).setUpdateInverse(true);
		/*}
		else {
			dirty();
			if(tempList == null) {
				org.hibernate.engine.CollectionEntry entry = getSession().getPersistenceContext().getCollectionEntry(this);
				tempList = newOwnedListFromCollectionEntry(entry);
			}
			tempList.add(index, value);
			queueOperation( new Add(index, value) );
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
	public Object remove(int index) {
		if(index >= 0 && index < size()) {
			return super.remove(index);
		}
		return null;
	}

	@Override
	public void setOwner(Object owner) {
		//System.out.println("List::setOwner(" + (owner == null ? "null" : "owner")  + ")");
		if(list != null && list instanceof utils.OwnedList) {
			((utils.OwnedList)list).setOwner(owner);
			//System.out.println("Passed Onto List");
		}
		super.setOwner(owner);
	}
/*
	final class Add implements DelayedOperation {
		private int index;
		private Object value;

		public Add(int index, Object value) {
			this.index = index;
			this.value = value;
		}
		public void operate() {
			((utils.OwnedList)list).setUpdateInverse(false);
			list.add(index, value);
			((utils.OwnedList)list).setUpdateInverse(true);
		}
		public Object getAddedInstance() {
			return value;
		}
		public Object getOrphan() {
			return null;
		}
	}

	final class SimpleAdd implements DelayedOperation {
		private Object value;
		
		public SimpleAdd(Object value) {
			this.value = value;
		}
		public void operate() {
			((utils.OwnedList)list).setUpdateInverse(false);
			list.add(value);
			((utils.OwnedList)list).setUpdateInverse(true);
		}
		public Object getAddedInstance() {
			return value;
		}
		public Object getOrphan() {
			return null;
		}
	}*/
}