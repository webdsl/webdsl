package test;

import java.util.*;

import javax.persistence.*;

import org.hibernate.Session;

import org.webdsl.querylist.HibernateQueryList;
import org.webdsl.querylist.QueryList;

@Entity @javax.persistence.Inheritance(strategy = javax.persistence.InheritanceType.SINGLE_TABLE) @javax.persistence.DiscriminatorColumn(name = "DISCRIMINATOR", discriminatorType = javax.persistence.DiscriminatorType.STRING, length = 255) public class User  implements org.webdsl.WebDSLEntity, Comparable<Object> { 
  public User () 
  { }
  
  public User(String name, int age) {
	  _name = name;
	  _age = age;
  }

  @Id @GeneratedValue private Long id;

  public Long getId()
  { 
    return id;
  }

  public void setId(Long id)
  { 
    this.id = id;
  }

  public int hashCode()
  { 
    if(getId() == null)
      return super.hashCode();
    else
      return getId().hashCode();
  }

  public int compareTo(org.webdsl.WebDSLEntity o)
  { 
    return getId().compareTo(((User)o).getId());
  }

  public boolean isInstance(Class<?> c)
  { 
    return c.isInstance(this);
  }

  public boolean instanceOf(String s)
  { 
    return s.equals("User") || s.equals("Object");
  }

  @org.hibernate.annotations.AccessType(value = "field") protected String _name = "";

  public String getName()
  { 
    return _name;
  }

  public void setName(String newitem)
  { 
    String item = newitem;
    String oldthing = getName();
    if(oldthing != null && item == null)
    { 
      item = oldthing;
    }
    else
      if(oldthing != null && item != null)
      { 
        item = oldthing;
      }
      else
        if(oldthing == null && item != null)
        { }
    _name = newitem;
  }

  @org.hibernate.annotations.AccessType(value = "field") protected Integer _age = 0;

  public Integer getAge()
  { 
    return _age;
  }

  public void setAge(Integer newitem)
  { 
    Integer item = newitem;
    Integer oldthing = getAge();
    if(oldthing != null && item == null)
    { 
      item = oldthing;
    }
    else
      if(oldthing != null && item != null)
      { 
        item = oldthing;
      }
      else
        if(oldthing == null && item != null)
        { }
    _age = newitem;
  }

  @OneToMany(mappedBy = "_author", targetEntity = Message.class, fetch = javax.persistence.FetchType.LAZY) @org.hibernate.annotations.Cascade({org.hibernate.annotations.CascadeType.PERSIST, org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.MERGE}) protected java.util.Set<Message> _messages = new java.util.LinkedHashSet<Message>();

  public java.util.Set<Message> getMessages()
  { 
    return _messages;
  }

  private QueryList<Message> _messagesQl = null;

  @Transient
  public QueryList<Message> getMessagesQL(Session hibSession) {
    if(_messagesQl == null) {
      _messagesQl = new HibernateQueryList<Message>(Message.class, hibSession, this, "messages", "author");
    }
    return _messagesQl;
  }

  public void setMessages(java.util.Set<Message> newitem)
  { 
    _messages = newitem;
  }

  public java.util.List<Message> getMessagesList()
  { 
    return new ArrayList(getMessages());
  }

  public void setMessagesList(java.util.List<Message> list1)
  { 
    setMessages(new java.util.LinkedHashSet<Message>(list1));
  }

  public int getMessagesLength()
  { 
    return getMessages().size();
  }

  public void removeFromMessages(Message item)
  { 
    getMessages().remove(item);
    item.setAuthor(null);
  }

  public void removeAllFromMessages()
  { 
    org.hibernate.Hibernate.initialize(getMessages());
    while(!getMessages().isEmpty())
    { 
      removeFromMessages(getMessages().iterator().next());
    }
  }

  public void addToMessages(Message item)
  { 
    Message oldthing = new Message();
    getMessages().add(item);
    item.setAuthor(this);
  }
  
  public String toString() {
	  return getName();
  }

  @Override
  public int compareTo(Object o) {
    return id.compareTo(((User)o).getId());
  }
}
