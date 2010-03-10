application test

section datamodel

  entity User{
    name     :: String
    children -> List<User>
  }
  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  
  define page root(){
    
    "name: " output(u.name)
 /*   if(u.children != null)
    {
      "children: " output(u.children)
    }
   */ 
    form{
      input(u.name)
      input(u.children)
      action("save",save())
    }
     
    action save()
    {
      u.save();
    }
    
  }
