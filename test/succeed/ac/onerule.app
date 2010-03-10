application test

section principal

  entity User{
    name :: String
  }

  var u1 : User := User{ name := "Bob" };

  principal is User with credentials name
  
  access control rules
    rule page root()
    {
      true
    }
    
  
section somesection  
    
  define page root(){
      action login(){
        securityContext.principal := u1;
      }
      action logout(){
        securityContext.principal := null;
      }
      if(!loggedIn())
      {
        "not logged in"
        form{
          action("login as Bob",login())
        }
        
      }
      if(loggedIn())
      {
        output(securityContext.principal.name)
        form{
          action("logout",logout())
        }
      }
  }