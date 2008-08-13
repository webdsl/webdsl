application test

section datamodel

  entity User{
    name     :: String
    children -> Set<User>
  }

  entity UserSet{
    users -> Set<User>
  }


  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  var u4:User := User{name := "eve" };
  var u5:User := User{name := "fred"};
  var u6:User := User{name := "guy"};
  var uset:UserSet := UserSet{users:={u2,u3,u4,u5,u6}};
  define page home(){
    
    "name: " output(u.name)
 /*   if(u.children != null)
    {
      "children: " output(u.children)
    }
   */ 
    form{
      input(u.name)
      select(u.children from uset.users)
      action(save(),"save")
      action save()
      {
        u.save();
      }
    }
     
    
  }