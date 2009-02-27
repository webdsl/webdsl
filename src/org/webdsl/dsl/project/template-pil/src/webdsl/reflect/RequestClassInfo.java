package webdsl.reflect;

public class RequestClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::Request";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{new pil.reflect.Field(this, "session", webdsl.reflect.TypeOfSession.typeOfSession())};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{new pil.reflect.Method(this, "get", pil.reflect.TypeOfString.typeOfString(), new pil.reflect.Class[]{pil.reflect.TypeOfString.typeOfString()})};
  }
}