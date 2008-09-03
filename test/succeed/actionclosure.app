application test

section datamodel

  entity User {
    username    :: String

  }
  
  define main() 
  {
    body()
  }
  
  var u:User := User{username := "0"};
  
  define page home()
  {
    main()
    action save() {
            u.username := "1" ;           
    }
    define body() {
      section {
        output(u.username)
   
        form { 
       
          action("save", save())
         
        }
      }
    }
  }
  