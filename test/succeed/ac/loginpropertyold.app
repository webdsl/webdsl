application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page home()
    {
      true
    }
    rule template main(){true}
    rule template body(){true}
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {
      if(securityContext.loggedIn)
      {
        output(securityContext.principal.name)
      }
    }
   }