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
  
  define body() {
    "default body"
  }
  
  var bob : User := User { username := "Bob"  email := "bob@gmail.com"};
  
  define page root()
  {
    main()
    action a() {}
    define body() {
      action change() {
        bob.save();
      }
      action cancelsave() {      }
      action cancelreturn() {          
        return root();
      }
      section {
        form {
        
          input(bob.username)
          action("change", change())
          action("cancel", cancelsave())
          
          action("cancelreturn", cancelreturn())
        }
        "User: "
        output(bob.username)
      }
    }
  }
