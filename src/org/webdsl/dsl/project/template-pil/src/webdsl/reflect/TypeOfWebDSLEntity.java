package webdsl.reflect;

public final class TypeOfWebDSLEntity  
{ 
  public final static pil.reflect.Class typeOfWebDSLEntity()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::WebDSLEntity"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::WebDSLEntity", new webdsl.reflect.WebDSLEntityClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::WebDSLEntity");
  }
}