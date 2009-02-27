package webdsl.reflect;

public final class TypeOfTemplateServlet  
{ 
  public final static pil.reflect.Class typeOfTemplateServlet()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::TemplateServlet"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::TemplateServlet", new webdsl.reflect.TemplateServletClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::TemplateServlet");
  }
}