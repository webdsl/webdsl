application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    username :: String
    check :: Bool
  }
  
  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    var u: User := User { username := "Bob" check := true };
    define body()
    {
      if(u.check)
      {
        output(u.username)
      }
    }
   }
