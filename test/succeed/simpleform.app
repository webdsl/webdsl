application test

section datamodel

  entity User{
    name :: String
    rank :: Int
  }
  
  define page home(){
    for(u:User)
    {
      output(u.name)
      outputString(u.name)
      outputText(u.name)
      output(u.rank)
      outputInt(u.rank)
    }
    "test page"
    var u : User := User{name := "bob"  rank := 3};
    form{
      "todo : copy input from variable"
      input(u.name)
      input(u.rank)
      action(save(),"save")
    }
    action save()
    {
      u.save();
    }

  }


