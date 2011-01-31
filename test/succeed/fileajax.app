application test

section datamodel

  entity ImageStore{
    storedimage :: Image
  }
  
  var u3_img := ImageStore{ };
  
  define page root(){
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
    placeholder status {}
    action dummy() {
      append(status, verify()); //this actions sets the compileroption IsAjax to true
    }
    action save() {
      u3_img.save();
      return root();       
    }
  }

  define imginputtemplate(){
    imginput()
  }

  define imginput(){
    input(u3_img.storedimage)
  }
  
  define ajax verify(){
    "used ajax"
  }