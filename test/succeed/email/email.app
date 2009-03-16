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
    
    function send(){
      email(testemail(this));
    }
  }
  
  function emailsendfunction(u:User){
    email(testemail(u));
  }

  var global_u : User := User {
    name := "bob"  
    mail := "webdslorg@gmail.com"
  };
  
  define page home() {
    output(global_u.name)
    output(global_u.mail)
    
    form {
      action("email",send())
    }
    action send() {
      email(testemail(global_u));
    }
    
    form {
      action("email (call in entity function)",send())
    }
    action send() {
      global_u.send();
    }
    
    form {
      action("email (call in global function)",send())
    }
    action send() {
      emailsendfunction(global_u);
    }
  
    form {
      input(global_u.name)
      input(global_u.mail)
      action("save",save())
    }
    action save() {
       global_u.save();
    }

  }


  define page confirmEmail(u:User){
  
    output(u.name) " confirmed"
  }
