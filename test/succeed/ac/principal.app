application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {
      if(loggedIn())
      {
        output(securityContext.principal.name)
      }
    }
   }