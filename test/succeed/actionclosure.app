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
  
  define page test()
  {
        main()
        define local body() {
          form { 
            group("Details") { 
            } 
            group() {
               action("Cancel", cancel1())
               action("Save", save())
            }
          }
          action cancel1() {
            cancel home();
          }
          action save() { 
            return home();
          }
        }
  }