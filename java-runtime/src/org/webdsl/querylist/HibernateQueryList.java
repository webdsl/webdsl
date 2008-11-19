package org.webdsl.querylist;

import java.util.List;

import org.hibernate.Session;

public class HibernateQueryList<T extends Comparable<Object>> extends MemoryQueryList<T> {
  private Session hibSession;
  private Object o;
  private String property;
  private Class t;

  public HibernateQueryList(Class<T> t, Session hibSession, Object o, String property, String inverseProperty) {
    super(inverseProperty);
    this.hibSession = hibSession;
    this.o = o;
    this.property = property;
    this.t = t;
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
    //List<T> result = hibSession.createQuery("from " + t.getN
    return super.list();
  }

  @Override
  public boolean remove(T o) {
    // TODO Auto-generated method stub
    return super.remove(o);
  }
}
