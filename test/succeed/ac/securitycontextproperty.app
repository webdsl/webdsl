application test

section principal

  define override body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  var u1 : User := User{ name := "Bob" };

  principal is User with credentials name
  
      
    predicate check2()
    {
      principal == null
    }
  
  access control rules
    rule page root()
    {
      principal == null && check() && check2()
    }
    
    predicate check()
    {
      principal == null
    }
    
  
section somesection  

  define page user(u:User){
    derive viewPage from u
  }
  
  define page editPage(u:User){
    derive editPage from u
  }
    
  define page root(){
    main()
    define body(){
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
  }
  
  define override main(){body()}
  