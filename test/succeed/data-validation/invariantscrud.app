application messages

  entity User{
    name :: String (
      validatedelete(name == "", "name should be empty before user can be deleted")
    , validatecreate(name != "", "name should not be empty before user can be created")
    , validateupdate(name != "", "name should not be empty before user can be updated")
    )
  }
  var u : User := User{ name := "bob" };
  var u1 : User := User{ name := "alice" };
  var u2 : User := User{ name := "charlie" };
  var u3 : User := User{ name := "dave" };
  
  define page root(){
    for(user:User) {
      output(user.name)
      form{
        action("delete_fail",action{user.delete();})
        action("delete_correct",action{user.name := ""; user.delete();})
      }
      form{
        input(user.name)
        action("update",action{user.save();})
      }
    }

    var newuser := User{};
        
    form{
      input(newuser.name)
      action("new user",action{newuser.save();})
    }
  }
