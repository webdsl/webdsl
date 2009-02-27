package webdsl.util.reflect;

public final class TypeOfFile  
{ 
  public final static pil.reflect.Class typeOfFile()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::util::File"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::util::File", new webdsl.util.reflect.FileClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::util::File");
  }
}