package utils;

import utils.*;
import java.io.Serializable;
import test.domain.*;
import javax.persistence.*;
import java.util.*;

@Entity public class File
{ 
  public File () 
  { }

  @Id @GeneratedValue private Long id;

  public Long getId()
  { 
    return id;
  }

  public void setId(Long id)
  { 
    this.id = id;
  }

  public boolean equals(Object o)
  { 
    return o != null && org.webdsl.tools.Utils.isInstance(o, File.class) && org.webdsl.tools.Utils.equal(((File)o).getId(), getId());
  }

  public int hashCode()
  { 
    if(getId() == null)
      return super.hashCode();
    else
      return getId().hashCode();
  }
  
  private java.sql.Blob	content	= null;

  private java.sql.Blob getContent(){
    return content;
  }

  private void setContent(java.sql.Blob content ){
    this.content = content;
  }

  public java.io.InputStream getContentStream()
            throws java.sql.SQLException
  {
    if (getContent() == null)
      return null;
    return getContent().getBinaryStream();
  }

  public void setContentStream( java.io.InputStream sourceStream )
            throws java.io.IOException
  {
    setContent( org.hibernate.Hibernate.createBlob( sourceStream ) );
  }

  @org.hibernate.annotations.AccessType(value = "field") protected String fileName = "";

  public String getFileName()
  { 
    return fileName;
  }

  public void setFileName(String newitem)
  { 
    fileName = newitem;
  }

  @org.hibernate.annotations.AccessType(value = "field") protected long sizeInBytes = 0;

  public long getSizeInBytes()
  { 
    return sizeInBytes;
  }

  public void setSizeInBytes(long newitem)
  { 
      sizeInBytes = newitem;
  }
    
  @org.hibernate.annotations.AccessType(value = "field") protected String contentType = "";

  public String getContentType() {
    return contentType;
  }
    
  public void setContentType(String contentType) {
    this.contentType = contentType;
  }
  
  
      
}