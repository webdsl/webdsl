application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    username :: String
  }

  var bob : User := User { username := "Bob" };

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    
    define body()
    {
      output(bob.username)
    }
   }