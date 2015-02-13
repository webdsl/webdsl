application test

section datamodel

  entity User{
    name :: String
  }
  
  define page root(){
    for(u1:User)
    {
      output(u1.name) " "
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


