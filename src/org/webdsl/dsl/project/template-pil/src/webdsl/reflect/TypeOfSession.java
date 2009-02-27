package webdsl.reflect;

public final class TypeOfSession  
{ 
  public final static pil.reflect.Class typeOfSession()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::Session"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::Session", new webdsl.reflect.SessionClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::Session");
  }
}