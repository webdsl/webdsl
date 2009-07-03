application test

section datamodel

  entity User{
    name :: String
    address :: String
  }

  var t_u1 := User{ name := "test1" }
  var t_u2 := User{ name := "test2" }
  var t_u3 := User{ name := "test3" }
  var t_u4 := User{ name := "test4" }

 
  define page home(){
    form{
      for(u1:User)
      {
        output(u1)
        output(u1.name)
        output(u1.address)
      }
    }
    "test page"
    var u : User := User{ name := "bob" address := "somewhere 1" };
    form{
      input(u.name)
      input(u.address)

      action("save",save())
    }

    action save() {
      u.save();
    }


  }


  define page user(u:User){
    "1 "
    var ps : List<User> :=
      select p from User as p
      where (~u = p)

    list{
      for(pers : User in ps) {
        listitem{ output(pers) }
      }
    }
    "2 " 
    var s := "test%"
    var ps2 : List<User> :=
      from User as u where u.name like ~s;

    list{
      for(pers : User in ps2) {
        listitem{ output(pers) }
      }
    }
  }