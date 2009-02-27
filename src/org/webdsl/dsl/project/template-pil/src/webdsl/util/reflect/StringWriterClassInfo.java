package webdsl.util.reflect;

public class StringWriterClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::util::StringWriter";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{new pil.reflect.Method(this, "println", null, new pil.reflect.Class[]{pil.reflect.TypeOfObject.typeOfObject()}), new pil.reflect.Method(this, "print", null, new pil.reflect.Class[]{pil.reflect.TypeOfObject.typeOfObject()})};
  }
}