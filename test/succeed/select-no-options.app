application test

section datamodel

  entity User{
    name     :: String
    child -> User
  }

  define page root(){
    for(us : User){
      output(us.name)
    }
  
    var u := User { name := "default" } 
    form{
      input(u.child, List<User>())
      input(u.name)
      action("save",save())
    }
    action save()
    {
      u.save();
    }
  }
