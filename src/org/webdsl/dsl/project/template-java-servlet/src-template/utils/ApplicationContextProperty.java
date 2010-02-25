package utils;


import java.util.*;
import javax.persistence.*;


@Entity public class ApplicationContextProperty
{
  public ApplicationContextProperty ()
  { }

  @Id @GeneratedValue private Long id;

  public Long getId()
  {
    return id;
  }

  private void setId(Long id)
  {
    this.id = id;
  }

  private String name;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
  
  @org.hibernate.annotations.Type(type = "utils.UUIDUserType") @javax.persistence.Column(name = "databaseId")//, length = 16) 
  private java.util.UUID databaseId;

  public UUID getDatabaseId() {
    return databaseId;
  }

  public void setDatabaseId(UUID databaseId) {
    this.databaseId = databaseId;
  }
}

