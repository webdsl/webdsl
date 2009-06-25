application test

  entity User{
    name :: String(id)
  }

  var u_1 := User { name := "Alice" }
  
  var u_2 := User { name := "Bob" }
  
  define page home(){
    for(u:User){
      "users: " output(u.name)
    }
    var name : String := "enter name here";
    form{
      input(name)
      action("save",save())
    }
    action save()
    {
      validate(findUser(name) == null,"User name taken");
      var newUser:User := User{ name := name };
      newUser.save();
      return home();
    }


  }


