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
     
     "confirm link in template: " confirmtemplate(us)
    }
  }
  
  define confirmtemplate(us:User){
    navigate(confirmEmail(us)){"confirm"} 
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
  
  define page root() {
    output(global_u.name)
    output(global_u.mail)
    
    form {
      action("email",send1())
    }
    action send1() {
      email(testemail(global_u));
    }
    
    form {
      action("email (call in entity function)",send2())
    }
    action send2() {
      global_u.send();
    }
    
    form {
      action("email (call in global function)",send3())
    }
    action send3() {
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
