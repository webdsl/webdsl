application test

section datamodel

  entity User{
    name :: String(id)
  }

  
  define page root(){
    for(u:User){
      "users: " output(u.name)
    }
 
    var name : String := "bob";
   
    "test page"

    form{
      input(name)
      
      action("save",save())
      action("save2",save2())
      action("save3",save3())
    }
    action save()
    {
      var newUser:User := getUniqueUser(name);
      newUser.save();
      return root();
    }
    
    action save2()
    {
      var newUser : User := User {name := name};
      if(!isUniqueUser(newUser)){
        newUser.name := newUser.name + random().toString();
      }
      newUser.save();
    
    }
    
        
    action save3()
    {
      var newUser : User := User {name := name};
      if(!isUniqueUserId(name)){
        newUser.name := newUser.name + random().toString();
      }
      newUser.save();
    
    }

  }



  test getUnique {
    var newUser:User := getUniqueUser("testname");
    newUser := getUniqueUser("testname");
    newUser := getUniqueUser("testname");
    newUser := getUniqueUser("testname");
    
    assert((from User).length == 1);
  }
