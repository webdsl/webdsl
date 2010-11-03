module ac

  principal is User with credentials name,password

  access control rules
    rule page *(*){ true }
    rule page admin(e:ALink){ e.event.organizer == principal }
    rule template *(*){ true }
    
  section ac templates
  
  
  extend entity Event {
    organizer -> User
  }
  
  var user_admin := User{ name := "admin" password := "admin" }

  entity User{
    name :: String
    password :: Secret
    email :: Email
  }

  define auth(){
    if(loggedIn()){
      signout()
    }
    else{
      signin()
    }
  }

  define signout(){
    "Logged in as: " output(securityContext.principal.name)
    " "
    form{
      submitlink action{logout();} {"Logout"}
    }
  }

  define signin(){
    var name := ""
    var pass : Secret := ""
    form{
      label("name: "){ input(name) }
      label("password: "){input(pass)}
      <br />
      submit action{
        validate(authenticate(name,pass), "The login credentials are not valid.");
        message("You are now logged in.");
      } {"login"}

    }
  }


  