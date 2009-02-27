package webdsl.reflect;

public class ResponseClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::Response";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{new pil.reflect.Field(this, "writer", webdsl.util.reflect.TypeOfStringWriter.typeOfStringWriter())};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{new pil.reflect.Method(this, "redirect", null, new pil.reflect.Class[]{pil.reflect.TypeOfString.typeOfString()}), new pil.reflect.Method(this, "setContentType", null, new pil.reflect.Class[]{pil.reflect.TypeOfString.typeOfString()})};
  }
}