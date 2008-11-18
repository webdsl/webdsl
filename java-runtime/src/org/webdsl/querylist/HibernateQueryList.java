package org.webdsl.querylist;

import java.util.List;

import org.hibernate.Session;

public class HibernateQueryList<T extends Comparable> extends MemoryQueryList<T> {
	private Session hibSession;

	public HibernateQueryList(Session hibSession) {
		this.hibSession = hibSession;
	}
	@Override
	public void add(T o) {
		super.add(o);
		hibSession.save(o);
	}

	@Override
	public boolean contains(T o) {
		// TODO Auto-generated method stub
		return super.contains(o);
	}

	@Override
	public T get(int index) {
		// TODO Auto-generated method stub
		return super.get(index);
	}

	@Override
	public List<T> list() {
		// TODO Auto-generated method stub
		return super.list();
	}

	@Override
	public boolean remove(T o) {
		// TODO Auto-generated method stub
		return super.remove(o);
	}

}
