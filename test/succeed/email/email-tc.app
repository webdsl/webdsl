application test

section datamodel

  define email testemail(us : User) {
    to(us.mail)
    from("webdslorg@gmail.com")
    subject("Email confirmation")
    
    par{ output(us) }
    par{
     "2"
    }
  }

  entity User {
    name :: String
    mail :: Email
  }

  define output(u:User){
    "1"
  }

  var global_u : User := User {
    name := "bob"  
    mail := "webdslorg@gmail.com"
  };
  
  define page root() {
    output(global_u.name)
    output(global_u.mail)
    
    form {
      action("email",send())
    }
    action send() {
      email(testemail(global_u));
    }

  }
  
