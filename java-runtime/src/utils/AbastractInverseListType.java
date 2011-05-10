package utils;

import java.util.Iterator;
import java.util.Map;

import org.hibernate.HibernateException;
import org.hibernate.collection.PersistentCollection;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.persister.collection.CollectionPersister;
import org.hibernate.usertype.UserCollectionType;

@SuppressWarnings("unchecked")
public abstract class AbastractInverseListType implements UserCollectionType {

	@Override
	public boolean contains(Object collection, Object entity) {
		return ((java.util.List) collection).contains(entity);
	}

	@Override
	public Iterator getElementsIterator(Object collection) {
		return ((java.util.List) collection).iterator();
	}

	@Override
	public Object indexOf(Object collection, Object entity) {
		return null;
	}

	@Override
	public abstract Object instantiate(int anticipatedSize);
	// return new x_entclass#x_prop#Set(anticipatedSize < 1 ? 0 : anticipatedSize );

	@Override
	public PersistentCollection instantiate(SessionImplementor session, CollectionPersister persister) throws HibernateException {
		return new utils.PersistentInverseList(session);
	}

	@Override
	public Object replaceElements(Object original, Object target,
			CollectionPersister persister, Object owner, Map copyCache,
			SessionImplementor session) throws HibernateException {
		java.util.List result = (java.util.List) target;
		result.clear();
		result.addAll((java.util.List) original);
		return result;
	}

	@Override
	public PersistentCollection wrap(SessionImplementor session, Object collection) {
		if ( session.getEntityMode() == org.hibernate.EntityMode.DOM4J ) {
			throw new IllegalStateException("dom4j not supported");
		}
		else {
			return new utils.PersistentInverseList( session, (java.util.List) collection );
		}
	}

}