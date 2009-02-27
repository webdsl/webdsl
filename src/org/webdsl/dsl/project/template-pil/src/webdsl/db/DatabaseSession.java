package webdsl.db;

import org.hibernate.*;
import org.hibernate.cfg.*;
import java.util.Properties;
import javax.persistence.*;

public class DatabaseSession {
  private Session session;
  private Transaction transaction;

  public DatabaseSession(Session session) {
    this.session = session;
    beginTransaction();
  }

  private void beginTransaction() {
    transaction = session.beginTransaction();
  }

  public void rollback() {
    transaction.rollback();
  }

  public void commit() {
    transaction.commit();
  }

  public void persist(Object o) {
    session.save(o);
  }

  public void delete(Object o) {
    session.delete(o);
  }
  
  public void refresh(Object o) {
    session.refresh(o);
  }

  public static Class classToClass(pil.reflect.Class cls) {
    String className = cls.getQualifiedId().replace("::", ".");
    try {
      java.lang.Class c = java.lang.Class.forName(className);
      return c;
    } catch(Exception e) {
      return null;
    }
  }

  public java.util.ArrayList<Object> getAll(pil.reflect.Class cls) {
    java.util.List l = session.createCriteria(classToClass(cls)).list();
    java.util.ArrayList<Object> l2 = new java.util.ArrayList<Object>(l);
    return l2;
  }
}
