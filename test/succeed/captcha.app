application test

section datamodel

  entity User{
    name :: String
  }
  
  define page root(){
    for(u:User)
    {
      output(u.name) " "
    }
    "test page"
    var u : User := User{
      name := "bob"  
    };
    form{
      input(u.name)
      captcha()
      action("save",save())
    }
    action save()
    {
      u.save();
    }

  }


