application test

section datamodel

  entity User{
    name :: String(id)
  }

  define page root(){
    for(u:User){
      "users: " output(u.name)
    }
 
    var name : String := "test-cache";

    form{
      action("save",save())

    }
    action save()
    {
      var u1:User := getUniqueUser("Cache");
      var u2:User := getUniqueUser("cache");
      validate(u1==u2, "error in getUniqueUser");
      
      var u3:Bool := isUniqueUser(User{name := "CaChE"});
      validate(!u3, "error in isUniqueUser");
      
      var u4:Bool := isUniqueUserId("CAChE");
      validate(!u4, "error in isUniqueUserId");
      
      var u5:Bool := isUniqueUserId("CACHE", User{name:="456"});
      validate(!u5, "error in isUniqueUserId(2)");
      
      return root();
    }
    
  }


