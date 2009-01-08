application test

section datamodel

  entity User{
    name     :: String
    children -> Set<User>
    val :: Bool
  }

  entity UserSet{
    users -> Set<User>
  }

  define main(){body()}
  define page user(U:User){derive viewPage from u}

  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  var u4:User := User{name := "eve" };
  var u5:User := User{name := "fred"};
  var u6:User := User{name := "guy"};
  var uset:UserSet := UserSet{users:={u2,u3,u4,u5,u6}};
  define page home(){
    main()
    define body(){
    "name: " output(u.name) " "
 //   if(u.children != null)
 //   {
      "children: " output(u.children)
 //   } 
    " "
    output(u.val)
    form{
      input(u.name)
      select(u.children from uset.users)
      input(u.val)
      action("save",save())
      action save()
      {
        u.save();
      }
    }
    }
  }