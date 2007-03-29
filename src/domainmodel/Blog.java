package org.blog;

import java.util.*;
import javax.persistence.*;
import org.blog.domainclasses.*;

public class Blog {

  public static void main(String[] args) {

    System.out.println("Testing generated Hibernat/JPA layer");

    try {
      
      EntityManager em = PersistenceUtil.getEM();
    
      // First unit of work
      EntityTransaction tx = em.getTransaction();
      tx.begin();
      User u = new User("name", null);

      Reply r1 = new Reply("bla", new Date(), u);

      Calendar c = Calendar.getInstance();
      c.set(3,5);
      Reply r2 = new Reply("bla2",c.getTime(), u);

      StringBuilder s = new StringBuilder(1000);
      for(int i = 0; i < 10; i++) s.append("c");
      Tag t = new Tag(s.toString());

      em.persist(t);
      // em.persist(u); <- not necessary because of cascade
      em.persist(r1);
      em.persist(r2);
      tx.commit();

      // Second unit of work
      tx = em.getTransaction();
      tx.begin();
      User duplicate = new User("name", null);
      em.persist(duplicate);
      r1.setUser(new User("usernew", null));
      em.persist(r1);
      em.remove(r2); // user 'name' should still be there!
      tx.commit();

      // Clean up
      em.close();
    
    } catch (javax.persistence.EntityExistsException e){
      System.out.println("Constraint violation detected!");
    
    } catch (Exception he) {

      System.out.println("Or not....:");
      //System.out.println(he.getMessage());
      he.printStackTrace(); 
    } 

  }

}
