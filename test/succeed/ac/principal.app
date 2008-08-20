application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  define main() 
  {
    "main"
    body()
  }
  
  define page home(){
    "home"
    main()
    define body()
    {
      "body"
      if(loggedIn())
      {
        output(securityContext.principal.name)
      }
      if(!loggedIn())
      {
        "not logged in"
      }
    }
   }
   
   
   access control rules 
     rule page home(){
       true
     }
     rule template main(){
       true
     }