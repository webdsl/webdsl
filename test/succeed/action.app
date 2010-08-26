application test

  entity User {
    name :: String
  }
 
  define menu(){
    body()
  }

  define body(){}
  define body2(){}

  define page root(){
    menu()
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