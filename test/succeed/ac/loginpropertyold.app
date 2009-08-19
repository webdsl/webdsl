application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page root()
    {
      true
    }
    rule template main(){true}
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    define body()
    {
      if(securityContext.loggedIn)
      {
        output(securityContext.principal.name)
      }
    }
   }