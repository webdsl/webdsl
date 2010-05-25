application test

  entity User{
    name :: String
  }
  
  define page root(){
  } 
  
  test flushfunction{    
    var u:User := User{name := "testuser"};
    u.save();
    flush();
    assert(findUserByName("testuser").length == 1,"number of users with name \"testuser\":"+findUserByName("testuser").length);
  }


