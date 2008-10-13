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
        
        output(u.storedfile)
        
        //action("custom download button",download(u))
     //   output(u.storedfile)
        actionLink("custom download link",download(u))
      }
    }
    "test page"
    var u : User := User{ name := "bob" };
    form{
      inputString(u.name)
      input(u.storedfile)

      action("save",save())
    }

    action save() {
      u.save();
    }
    action download(u:User) {
      u.storedfile.download();
    }

  }



  entity User2{
    name :: String
    storedimage :: Image
  }
  
  define page home2(){
    form{
      for(u:User2)
      {
        output(u.storedimage)
        //outputString(u.name)
        //action("custom image download button",downloadimage(u))
      }
    }
    "test page"
    var u : User2 := User2{ name := "alice" };
    form{
      inputString(u.name)
      input(u.storedimage)
      action("save image",save())
    }
    action save() {
      u.save();
    }

    action downloadimage(u:User2) {
      u.storedimage.download();
    }
  }




