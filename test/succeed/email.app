application test

section datamodel

  define email testemail(us : User) {
    to(us.mail)
    from("webdslorg@gmail.com")
    subject("Email confirmation")
    
    par{ "Dear " output(us.name) ", " }
    par{
     "Please confirm the receipt of this message by visiting the following page "
     navigate(confirmEmail(us)){"confirm"}
    }
  }

  entity User {
    name :: String
    mail :: Email
  }

  var u : User := User {
    name := "bob"  
    mail := "webdslorg@gmail.com"
  };
  
  define page home() {
    output(u.name)
    output(u.mail)
    
    
  form {
    action("email",send())
  }
    action send() {
      email(testemail(u));
    }
  
    form {
      input(u.name)
      input(u.mail)
      action("save",save())
    }
    action save() {
       u.save();
    }

  }


  define page confirmEmail(u:User){
  
    output(u.name) " confirmed"
  }
