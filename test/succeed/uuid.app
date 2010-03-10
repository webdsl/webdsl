application test

section datamodel

  entity User{
    username :: String
  }

  var global_u : User := User { username := "Dave" };

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
