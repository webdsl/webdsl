package utils;

import java.io.Serializable;
import org.hibernate.collection.PersistentList;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.persister.collection.CollectionPersister;

@SuppressWarnings({ "unchecked", "serial" })
public class PersistentOwnedList extends PersistentList {
	public PersistentOwnedList(SessionImplementor session) {
		super(session);
	}

	public PersistentOwnedList(SessionImplementor session, java.util.List list) {
		super(session, list);
	}

	@Override
	public void beforeInitialize(CollectionPersister persister, int anticipatedSize) {
		super.beforeInitialize(persister, anticipatedSize);

		// The super method just initialized the list, so we need to pass on the owner
		if(list != null && list instanceof utils.OwnedList) {
			((utils.OwnedList)list).setOwner(getOwner());
		}
	}

	@Override
	public void beginRead() {
		((utils.OwnedList)list).setDoEvents(false); // This prevents events, like inverse updates, while initializing
		super.beginRead();
	}

	@Override
	public boolean endRead() {
		boolean result = super.endRead();
		((utils.OwnedList)list).setDoEvents(true); // We should resume updating the inverse, because initialization is complete
		return result;
	}

	@Override
	public boolean add(Object value) {
		if(value == null) {
			return false;
		}

		return super.add(value);

	}

	@Override
	public void add(int index, Object value) {
		if(value == null || index < 0 || index > size()) {
			return;
		}

		super.add(value);
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
		if(list != null && list instanceof utils.OwnedList) {
			((utils.OwnedList)list).setOwner(owner);
		}
		super.setOwner(owner);
	}

	@Override
	public void initializeFromCache(CollectionPersister persister, Serializable disassembled, Object owner)
	throws org.hibernate.HibernateException {
		Serializable[] array = ( Serializable[] ) disassembled;
		int size = array.length;
		beforeInitialize( persister, size );
		((utils.OwnedList)list).setDoEvents(false);
		for ( int i = 0; i < size; i++ ) {
			list.add( persister.getElementType().assemble( array[i], getSession(), owner ) );
		}
		((utils.OwnedList)list).setDoEvents(true);
	}
}