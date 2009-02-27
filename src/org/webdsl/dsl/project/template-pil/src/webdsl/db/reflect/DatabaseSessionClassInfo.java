package webdsl.db.reflect;

public class DatabaseSessionClassInfo extends pil.reflect.Class 
{ 
  public pil.reflect.Class getSuperClass()
  { 
    return pil.reflect.TypeOfObject.typeOfObject();
  }

  public String getQualifiedId()
  { 
    return "webdsl::db::DatabaseSession";
  }

  public pil.reflect.Field[] getFields()
  { 
    return new pil.reflect.Field[]{};
  }

  public pil.reflect.Method[] getMethods()
  { 
    return new pil.reflect.Method[]{new pil.reflect.Method(this, "rollback", null, new pil.reflect.Class[]{}), new pil.reflect.Method(this, "commit", null, new pil.reflect.Class[]{}), new pil.reflect.Method(this, "refresh", null, new pil.reflect.Class[]{pil.reflect.TypeOfObject.typeOfObject()}), new pil.reflect.Method(this, "getAll", pil.reflect.TypeOfList.typeOfList(), new pil.reflect.Class[]{pil.reflect.reflect.TypeOfClass.typeOfClass()}), new pil.reflect.Method(this, "persist", null, new pil.reflect.Class[]{pil.reflect.TypeOfObject.typeOfObject()}), new pil.reflect.Method(this, "delete", null, new pil.reflect.Class[]{pil.reflect.TypeOfObject.typeOfObject()})};
  }
}