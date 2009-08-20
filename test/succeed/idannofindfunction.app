application test

  entity User{
    firstname :: String(id)
  }

  var u_1 := User { firstname := "Alice" }
  
  var u_2 := User { firstname := "Bob" }
  
  define page root(){
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
      validate(findUser(enteredname) == null,"User name taken");
      var newUser:User := User{ firstname := enteredname };
      newUser.save();
      return root();
    }


  }


