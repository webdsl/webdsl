application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  define main() 
  {
    "main"
    body()
  }
  
  define page root(){
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
     rule page root(){
       true
     }
     rule template main(){
       true
     }