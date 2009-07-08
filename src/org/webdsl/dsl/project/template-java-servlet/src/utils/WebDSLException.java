package utils;

import java.util.Map;
import java.util.HashMap;

public class WebDSLException extends RuntimeException {
    
  org.webdsl.WebDSLEntity entity;	
	
  public WebDSLException(org.webdsl.WebDSLEntity e){
      this.entity = e;
  }
    
  public org.webdsl.WebDSLEntity getEntity(){
	  return entity;
  }
  
  public void setEntity(org.webdsl.WebDSLEntity e){
	  entity = e;
  }
}
