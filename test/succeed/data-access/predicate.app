application test

imports templates

section principal

entity User {
  username :: String(id, name, inline)
  password :: Secret
  entries -> Set<Entry> (inverse=Entry.sender)
}

entity Entry {
  sender   -> User
  date     :: DateTime
  message  :: Text
}

//  var Current : User;

  allow write Entry.message if sender == securityContext.principal

  principal is User with credentials name
  
  access control rules
    rule page *(*)
    {
      true
    }
    rule template *(*)
    {
      true
    }
    

section somesection  

  define page root(){
//    title{"Guestbook"}
    main()
    define body() {
      table {
          header { "Sender" "Entry" "Action" }
         for(m : Entry order by m.date desc) {
              row { 
                output(m.sender.username) 
              	 output(m.message) 
              	navigate(editEntry(m)) { "Edit" }
              	}
          }
      }

    if(loggedIn())
      {
      addEntryTemplate()
      }
      menuBar() 
    }
  }

define menuBar() {
    if(loggedIn())
      {
        form{
          action("logout",logout())
        }
        action logout(){
          securityContext.principal := null;
          return root();
        }
     }     else {
        navigate(login("")){ "login" }     
        navigate(register("")){ "register" } 
     }   
}
 
define page editEntry(m : Entry) {
    main()
    define body() {
        editEntryTemplate(m)
    }
}

define editEntryTemplate(m : Entry) {
  form {
    table {
      row { "Message: " input(m.message) }
    }
    action("Save", save())
    action("Delete", delete())
  }
  action save() {
    m.save();
    return root();
  }
  action delete() {
    m.delete();
    return root();
  }
}

 define addEntryTemplate() {
    var msg : String;
    section {
      section { 
        header{ "Add entry" } 
        form {
          table {
            row { "Message: " input(msg) }
          }
          action("Add", save())
        }
        action save() {
	    var m := Entry{};
	    m.sender := securityContext.principal;
	    m.message := msg;
         m.date := today();
          m.save();
          return root();
        }
      }
  }
}
 
 
  define page login(msg : String){
    main()
    define body() {
      var username : String;
      var password : Secret;
      form { 
	    output(msg)
        table {
          row{ "Username: " input(username) }
          row{ "Password: " input(password) }
          row{ action("Sign in", signin()) "" }
        }
        navigate(register("")){ "register" }     
        action signin() {
          for (us : User where us.username == username) {
            if (us.password.check(password)) {
              securityContext.principal := us;
              securityContext.loggedIn := true;
              return root();
            }
          }
          securityContext.loggedIn := false;
          return login("Wrong combination of user name and password");
        }
      }
    }
  }

define page register(msg : String) {
//  title {"New User Registration"}
  main()
  define body() {
    var user : User := User{};
    output(msg)
    form {
      par { "Username: " input(user.username) }
      par { "Password: " input(user.password) }
      action("Register", newUser())
    }
    action newUser() {
      for(u : User where u.username == user.username) {
        return register("User already registered. Sorry.");
      }
      user.password := user.password.digest();
      user.save();
      return login("Successfully registered. Please log in");
    }
  }
}
