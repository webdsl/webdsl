application test

section datamodel

  entity User {
    username    :: String

  }
  
  define main() 
  {
    body()
  }
  
  define body() {
    "default body"
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

  define page test2(u:User)
  {
    derive editPage from u
  }
 

  define page test()
  {
        main()
        define body() {
          form { 
            group("Details") { 
            } 
            group() {
               
               action("Save", save())
                 action("Cancel", cancel()) 
         
            }
          }
     
             action save() { 
            return home();
          }
                    action cancel() {
            cancel home();
          }
     
       
        }
  }
 