application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User {
    username    :: String
    email       :: Email
  }
  
  define main() 
  {
    body()
  }
  
  define page home()
  {
    main()
  
    define body() {
      section {
        form { 
       
          action("Register", createUser())
          action createUser() {
            
            var user:User := User{username := "1"};
           
            var users:List<User> := [user]; 
            
            var l:Int := users.length;

          }
        }
      }
    }
  }
  