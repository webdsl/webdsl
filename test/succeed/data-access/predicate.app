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
         row { output("Sender") output("Entry") output("Action") }
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
	 }
  }

 
define page editEntry(m : Entry) {
    main()
    define body() {
        editEntryTemplate(m)
    }
}

define page logout() {
   main()
   define body() {  
        form{
          action("logout",logout())
        }
        action logout(){
          securityContext.principal := null;
          return root();
        }
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
//    var entry := Entry{ sender := securityContext.principal };
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
         var entry := Entry{};
         entry.sender := securityContext.principal;
         entry.message := msg;
         entry.date := now();
          entry.save();
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
        action signin() {
          for (user : User where user.username == username) {
            if (user.password.check(password)) {
              securityContext.principal := user;
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
    var user := User{};
    var confirmation : Secret;
    output(msg)
    form {
        table {
          row{ "Username: " input(user.username) }
          row{ "Password: " input(user.password) }
          row{ "Confirm: " input(confirmation) }
          row{ "" action("Register", newUser()) }
        }
    }
    action newUser() {
     if (confirmation != user.password) {
        return register("Passwords do not match.");
      }
      for(u : User where u.username == user.username) {
        return register("User already registered. Sorry.");
      }
      user.password := user.password.digest();
      user.save();
      securityContext.principal := user;
      securityContext.loggedIn := true;
      return root();
    }
  }
}
