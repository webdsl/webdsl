application test

section datamodel


  entity User{
    name :: String
    storedfile :: File
  }
  
  define page home(){
    form{
      for(u:User)
      {
      
        outputString(u.name)
        outputFile(u.storedfile)
        //output(u.storedfile)
        action("download",download(u))
      
      }
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
    action download(u:User)
    {
      u.storedfile.download();
    }

  }


