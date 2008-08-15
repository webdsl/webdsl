application test

section datamodel

  entity User{
    name     :: String
    child-> User
  }

  entity UserSet{
    users -> Set<User>
  }


  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  var uset:UserSet := UserSet{users:={u2,u3}};
  define page home(){
    
    "name: " output(u.name)
 /*   if(u.children != null)
    {
      "children: " output(u.children)
    }
   */ 
    form{
      input(u.name)
      select(u.child from uset.users)
      action("save",save())
      action save()
      {
        u.save();
      }
    }
     
    
  }