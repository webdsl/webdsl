application test

  entity User{
    firstname :: String
  }

  var u_1 := User { firstname := "Alice" }
  var u_2 := User { firstname := "Bob" }
  
  define page home(){
    for(u:User){
      "users: " output(u.firstname)
    }
    var enteredname : String := "enter firstname here";
    form{
      input(enteredname)
      action("save",save())
    }
    action save()
    {
      validate(findUserByFirstname(enteredname) == null,"User name taken");
      var newUser:User := User{ firstname := enteredname };
      newUser.save();
      return home();
    }


  }


