application test

section datamodel


  entity User{
    name :: String
    storedfile :: File
  }
  
  define page home(){
    for(u:User)
    {
      outputString(u.name)
      outputFile(u.storedfile)
      //output(u.storedfile)
    }
    "test page"
    var u : User := User{
      name := "bob"  
 
    };
    form{
      inputString(u.name)
      inputFile(u.storedfile)
      //input(u.storedfile)
      action("save",save())
    }
    action save()
    {
      u.save();
    }

  }


