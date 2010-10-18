application versionfour

  imports data
  imports lib
  imports ac
  imports ui
  imports invite

  extend entity Event {
    organizer -> User
  }

  define page root(){
    //authentication()<br />
    auth()
    <br />
    form{
      submitlink action{
        var e := Event{
          organizer := securityContext.principal
          slots := [ Slot{ } ]
        };
        e.save();
        return new(e);
      } { "Create new event" }
    }

    <br />
    for(e:Event){
      showEvent(e)
    } separated-by{ <br />  }

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

