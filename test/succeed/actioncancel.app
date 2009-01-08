application test

section datamodel

  entity User {
    username    :: String
    email       :: Email
  }
  
  define main() 
  {
    body()
  }
  
  var bob : User := User { username := "Bob"  email := "bob@gmail.com"};
  
  define page home()
  {
    main()
    action a() {}
    define body() {
      section {
        form {
        
          input(bob.username)
          action("change", change())
          action change() {
            bob.save();
          }
          action("cancel", cancelsave())
          action cancelsave() {
          }
          
          action("cancelreturn", cancelreturn())
          action cancelreturn() {
          
            return home();
          }
        }
        "User: "
        output(bob.username)
      }
    }
  }
