application test

section principal

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
    rule page home()
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
    
  define page home(){
    main()
    define body(){
      if(!loggedIn())
      {
        "not logged in"
        form{
          action("login as Bob",login())
        }
        action login(){
          securityContext.principal := u1;
        }
        
      }
      if(loggedIn())
      {
        output(securityContext.principal.name)
        form{
          action("logout",logout())
        }
        action logout(){
          securityContext.principal := null;
        }
      }
    }
  }
  
  define main(){body()}