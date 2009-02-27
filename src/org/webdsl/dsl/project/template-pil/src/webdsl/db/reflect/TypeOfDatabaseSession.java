package webdsl.db.reflect;

public final class TypeOfDatabaseSession  
{ 
  public final static pil.reflect.Class typeOfDatabaseSession()
  { 
    if(!pil.reflect.ClassCache.classCache.containsKey("webdsl::db::DatabaseSession"))
    { 
      pil.reflect.ClassCache.classCache.put("webdsl::db::DatabaseSession", new webdsl.db.reflect.DatabaseSessionClassInfo());
    }
    else
    { }
    return pil.reflect.ClassCache.classCache.get("webdsl::db::DatabaseSession");
  }
}