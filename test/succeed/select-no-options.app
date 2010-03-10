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
      select(u.child from List<User>())
      input(u.name)
      action("save",save())
    }
    action save()
    {
      u.save();
    }
  }
