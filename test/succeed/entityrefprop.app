application test

section datamodel

  entity User{
    name     :: String
    child -> User
  }
  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  
  define page root(){
    
    "name: " output(u.name)
    if(u.child != null)
    {
      "child: " output(u.child.name)
    }
    
    form{
      input(u.name)
      input(u.child)
      action("save",save())
    }
    action save()
    {
      u.save();
    }   
  }
