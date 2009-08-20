application test

  entity User{
    firstname :: String
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
      validate(findUserByFirstname(enteredname).length == 0,"User name taken");
      message("There are " + findUserByFirstnameLike(enteredname).length + " similar usernames");
      var newUser:User := User{ firstname := enteredname };
      newUser.save();
      return root();
    }


  }


