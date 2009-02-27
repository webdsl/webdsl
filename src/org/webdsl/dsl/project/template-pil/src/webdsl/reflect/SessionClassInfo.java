package webdsl.reflect;

public class SessionClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::Session";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{new pil.reflect.Method(this, "set", null, new pil.reflect.Class[]{pil.reflect.TypeOfString.typeOfString(), pil.reflect.TypeOfObject.typeOfObject()}), new pil.reflect.Method(this, "get", pil.reflect.TypeOfObject.typeOfObject(), new pil.reflect.Class[]{pil.reflect.TypeOfString.typeOfString()})};
  }
}