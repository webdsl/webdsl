package webdsl.util.reflect;

public final class TypeOfStringWriter  
{ 
  public final static pil.reflect.Class typeOfStringWriter()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::util::StringWriter"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::util::StringWriter", new webdsl.util.reflect.StringWriterClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::util::StringWriter");
  }
}