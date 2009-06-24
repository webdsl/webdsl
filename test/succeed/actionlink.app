application test

section datamodel

  entity User {
    username    :: String
    email       :: Email
  }
  
  define main() 
  {
    for(u:User){
      output(u.username) " "
    }
    body()
  }

  define body() {
    "default body"
  }
  
  define page home()
  {
    main()
    define body() {
      section {
        form { 
          actionLink("Register", createUser())
          action createUser() {
            var user:User := User{username := "1"};
            var users:List<User> := [user]; 
            var l:Int := users.length;
            user.save();
            return home2();

          }
        }
      }
    }
  }
  
  define page home2()
  {
    main()
    define body(){
      form { 
        actionLink("return", ret())
        action ret() {
            return home();
        }
      }
    }
  }