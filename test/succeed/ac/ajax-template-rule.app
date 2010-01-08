application test

  entity User{
    name :: String
  }

  principal is User with credentials name
  
access control rules
  rule ajaxtemplate test(uzer:User){
    uzer == principal
  }
  rule page root(){true}

section somesection  
  
  var u1 := User{ name := "SUCCESS" }

  define ajax test(u:User){
    output(u.name)
  }
  
  define page root(){
      placeholder one {
        "username goes here"
      }
      
      form {
        action("login",action{ securityContext.principal := u1; } )
        action("logout",action{ securityContext.principal := null; } )
        action("replace it if logged in",save())[ajax]    
      }

      action save() {
        replace(one, test(u1));
      }
  }
  