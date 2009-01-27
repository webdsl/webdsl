application test

section datamodel

  entity User{
    name :: String(id)
  }

  
  define page home(){
    for(u:User){
      "users: " output(u.name)
    }
 
    var name : String := "bob";
   
    "test page"

    form{
      input(name)
      
      action("save",save())
    }
    action save()
    {
      var newUser:User := getUniqueUser(name);
      newUser.save();
      return home();
    }

  }


