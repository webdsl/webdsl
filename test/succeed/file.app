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
        output(u.name)
        
        output(u.storedfile)
        <br/>
        "content as string: "
        output(u.storedfile.getContentAsString())
        
        //action("custom download button",download(u))
     //   output(u.storedfile)
        downloadlink download(u) {"custom download link"}
      }
    }
    "test page"
    var user : User := User{ name := "bob" };
    form{
      input(user.name)
      input(user.storedfile)

      action("save",save())
      actionLink("save",save())
      action("save and log contentasstring",saveandlog())
    }
    action saveandlog() {
      log(user.storedfile.getContentAsString());
      user.save();
    }

    action save() {
      user.save();
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
      for(u2:User2)
      {
        output(u2.storedimage)
        //outputString(u.name)
        //action("custom image download button",downloadimage(u))
      }
    }
    "test page"
    var u : User2 := User2{ name := "alice" };
    form{
      group("image"){
        row{column{input(u.name)}}
        row{column{input(u.storedimage)}}
        row{column{action("save image",save())}}
      }
    }
    action save() {
      u.save();
    }

    action downloadimage(u2:User2) {
      u2.storedimage.download();
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
  
