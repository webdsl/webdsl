package webdsl.reflect;

public final class TypeOfResponse  
{ 
  public final static pil.reflect.Class typeOfResponse()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::Response"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::Response", new webdsl.reflect.ResponseClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::Response");
  }
}