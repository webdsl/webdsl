application messages

  entity User{
    name :: String
  }
  var u : User := User{ name := "bob" };
  var u1 : User := User{ name := "alice" };
  
  define page root(){
    for(user:User) {
      output(user.name)
    }
    
    navigate(somepage()){"link"}
    
    form {
      input(u.name)
      action("save",save())
    }
    action save() {
      u.save();
      message("1: user name changed to "+u.name);
      message("2: user name changed to "+u.name);
      message("3: user name changed to "+u.name);
      message("4: user name changed to "+u.name);
      return somepage();
    }
  }
  
  define page somepage(){
    "somepage"  
  }
