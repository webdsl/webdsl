application test

section datamodel

  entity User{
    name :: String
    storedfile :: File
  }
  
  define navigation(){
    navigate(root()){"test1"}
    navigate(home2()){"test2"}
    navigate(home3()){"test3"}  
  }
  
  define page root(){

    navigation()
    form{
      for(u:User)
      {
        outputString(u.name)
        
        output(u.storedfile)
        
        //action("custom download button",download(u))
     //   output(u.storedfile)
        downloadLink("custom download link",download(u))
      }
    }
    "test page"
    var u : User := User{ name := "bob" };
    form{
      inputString(u.name)
      input(u.storedfile)

      action("save",save())
      actionLink("save",save())
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
    navigation()
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
      group("image"){
        row{column{inputString(u.name)}}
        row{column{input(u.storedimage)}}
        row{column{action("save image",save())}}
      }
    }
    action save() {
      u.save();
    }

    action downloadimage(u:User2) {
      u.storedimage.download();
    }
  }
  
  entity ImageStore{
    storedimage :: Image
  }
  
  var u3_img := ImageStore{ };
  define page home3(){
    navigation()
    form{
      for(i : ImageStore)
      {
        output(i.storedimage)
      }
    }
    "test page"

    form{
      group("image"){
        imginputtemplate()
        action("save image",save())
      }
    }
    action save() {
      u3_img.save();
    }
  }

  define imginputtemplate(){
    imginput()
  }

  define imginput(){
    input(u3_img.storedimage)
  }
  
