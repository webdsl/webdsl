application test

section datamodel

  entity User{
    username :: String
    uuid :: UUID
  }

  var global_u : User := User { username := "Dave" };
  var global_default : User := User {};
  var global_null : User := User {uuid := null};
  var global_string : User := User {uuid := UUIDFromString("12345678-90ab-cdef-1234-567890abcdef")};

  define page root(){
    action test1()
    {
      global_u.username := randomUUID().toString();
      global_u.save();
    }
    action test2()
    {       
      global_u.username := UUIDFromString(global_u.username).toString();
      global_u.save();  
    }
    
    output(global_u.username)
    
    form{
      input(global_u.username)

      action("test1",test1())
      action("test2",test2())
    }
  }

test {
  assert(global_default.uuid == null);
  assert(global_null.uuid == null);
  assert(global_string.uuid == UUIDFromString("12345678-90ab-cdef-1234-567890abcdef"));
  assert(UUIDFromString(global_string.uuid.toString()) == global_string.uuid);
}