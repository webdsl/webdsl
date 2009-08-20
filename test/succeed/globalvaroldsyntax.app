application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    username :: String
  }

  globals {
    var bob : User := User { username := "Bob" };
  }
  
  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    
    define body()
    {
      output(bob.username)
    }
   }
