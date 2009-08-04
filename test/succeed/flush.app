application test

  entity User{
    name :: String
  }
  
  define page home(){
    
    for(u:User){
      output(u.name)
    }
    
    var u:User := User{name := "testuser"};
    
    form{
      input(u.name)
      action("save",save())  
    } 
    action save(){
      u.save();
      flush();
      validate(false,"action cancelled but flush should still have saved the user, number of users with name \"testuser\":"+findUserByName("testuser").length);
    }
  }
