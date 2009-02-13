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

  private String databaseId;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getDatabaseId() {
    return databaseId;
  }

  public void setDatabaseId(String databaseId) {
    this.databaseId = databaseId;
  }
}

