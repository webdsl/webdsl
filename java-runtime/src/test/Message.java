package test;

import javax.persistence.*;


@Entity
@javax.persistence.Inheritance(strategy = javax.persistence.InheritanceType.SINGLE_TABLE)
@javax.persistence.DiscriminatorColumn(name = "DISCRIMINATOR", discriminatorType = javax.persistence.DiscriminatorType.STRING, length = 255)
public class Message implements org.webdsl.WebDSLEntity, Comparable<Object> {
  public Message() {
  }

  @Id
  @GeneratedValue
  private Long id;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public int hashCode() {
    if (getId() == null)
      return super.hashCode();
    else
      return getId().hashCode();
  }

  public int compareTo(org.webdsl.WebDSLEntity o) {
    return getId().compareTo(((Message) o).getId());
  }


    public String get_WebDslEntityType() {
    return "Message";
    }

  public boolean isInstance(Class<?> c) {
    return c.isInstance(this);
  }

  public boolean instanceOf(String s) {
    return s.equals("Message") || s.equals("Object");
  }

  @ManyToOne(fetch = javax.persistence.FetchType.LAZY)
  @JoinColumn(name = "Messageauthor")
  @org.hibernate.annotations.Cascade( { org.hibernate.annotations.CascadeType.PERSIST,
      org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.MERGE })
  @org.hibernate.annotations.AccessType(value = "field")
  protected User _author = null;

  public User getAuthor() {
    return _author;
  }

  public void setAuthor(User newitem) {
    User item = newitem;
    User oldthing = getAuthor();
    if (oldthing != null && item == null) {
      item = oldthing;
      if (item.getMessages().contains(this)) {
        item.getMessages().remove(this);
      }
    } else if (oldthing != null && item != null) {
      if (!item.getMessages().contains(this)) {
        item.getMessages().add(this);
      }
      item = oldthing;
      if (item.getMessages().contains(this)) {
        item.getMessages().remove(this);
      }
    } else if (oldthing == null && item != null) {
      if (!item.getMessages().contains(this)) {
        item.getMessages().add(this);
      }
    }
    _author = newitem;
  }

  @Column(length = 1000000)
  @org.hibernate.annotations.AccessType(value = "field")
  protected String _text = "";

  public String getText() {
    return _text;
  }

  public void setText(String newitem) {
    String item = newitem;
    String oldthing = getText();
    if (oldthing != null && item == null) {
      item = oldthing;
    } else if (oldthing != null && item != null) {
      item = oldthing;
    } else if (oldthing == null && item != null) {
    }
    _text = newitem;
  }

  @Temporal(TemporalType.TIMESTAMP)
  @org.hibernate.annotations.AccessType(value = "field")
  protected java.util.Date _date = new java.util.Date();

  public java.util.Date getDate() {
    return _date;
  }

  public void setDate(java.util.Date newitem) {
    java.util.Date item = newitem;
    java.util.Date oldthing = getDate();
    if (oldthing != null && item == null) {
      item = oldthing;
    } else if (oldthing != null && item != null) {
      item = oldthing;
    } else if (oldthing == null && item != null) {
    }
    _date = newitem;
  }

  public String getName() {
    if (getId() != null) {
      return getId().toString();
    } else {
      return "";
    }
  }

  public String toString() {
    return getAuthor() + ": " + getText();
  }

  @Override
  public int compareTo(Object o) {
    return id.compareTo(((Message)o).getId());
  }
  
  public java.lang.Integer getVersion() { return 0; } //MW: always valid? 
}
