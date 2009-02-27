package webdsl.reflect;

public final class TypeOfRequest  
{ 
  public final static pil.reflect.Class typeOfRequest()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::Request"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::Request", new webdsl.reflect.RequestClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::Request");
  }
}