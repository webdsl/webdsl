application testacpage

    principal is User with credentials name, password
  
    entity User{
      name :: String
      password :: Secret
    }
  
    define override login(){
      var username := ""
      var password : Secret := ""
      form{ 
        label("Name: "){ input(username) }
        label("Password: "){ input(password) }
        captcha()
        submit login() {"Log In"}
      }
      action login(){
        validate(authenticate(username,password), "The login credentials are not valid.");
        message("You are now logged in.");
      }
    }
  
    define override logout(){
      "Logged in as " output(securityContext.principal)
      form{
        submitlink logout() {"Log Out"}
      }
      action logout(){
        securityContext.principal := null;
      }
    }
      
    define page root(){
      login()
      " "
      logout()
    }
    
    init{
      var u1 : User := User{ name := "test" password := ("test" as Secret).digest() };
      u1.save();
    }
    
    access control rules
      
      rule page root(){
        true
      }
    
