package webdsl.reflect;

public class TemplateServletClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::TemplateServlet";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{};
  }
}