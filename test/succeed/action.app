application test

  entity User {
    name :: String
  }
 
  define menutemplate(){
    body()
  }

  define body(){}
  define body2(){}

  page root(){
    menutemplate()
    define body(){
      for(usr:User){
        form{
          action("select",sel(usr))
        }
      }
      form{
        action("create new admin",action{ findUserByName(""); })
      }
    }
    action sel(u:User){
      return root();
    }

    define body2(){
      form{
        action("import",import())
      }
      action import(){
      }
    }
  }
  
  page unused(){
    body2
    enroll
    enroll1(true)
  }
 
  // r6036 the analysis for variables used in action code is not picking up 'agree' 
  template enroll() {
    var agree: Bool := false
    action enroll() { 
      validate(agree, "agree"); 
    }
  }
  template enroll1(agree1: Bool) {
    action enroll() { 
      validate(agree1, "agree"); 
    }
  }
