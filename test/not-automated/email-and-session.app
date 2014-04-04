//  session variable lookup failed for name: securityContext

application test

  define email testemail(us : User) {
    to(us.mail)
    from("webdslorg@gmail.com")
    subject("Email confirmation")
    
    par{ "Dear " output(us.name) ", " }
    par{
     "Please confirm the receipt of this message by visiting the following page "
     navigate confirmEmail(us){"confirm"}
     
     "confirm link in template: " confirmtemplate(us)
    }
  }
  
  template confirmtemplate(us:User){
    navigate confirmEmail(us) {"confirm"} 
  }

  entity User {
    name :: String
    mail :: Email
    
    function send(){
      email testemail(this);
    }
  }

  var global_u : User := User {
    name := "bob"  
    mail := "webdslorg@gmail.com"
  }
  
  page root() {
    output(global_u.name)
    output(global_u.mail)
    form {
      submit action{ global_u.send(); } {"send"}
    }
  }

  define page confirmEmail(u:User){
    output(u.name) " confirmed"
  }

  principal is User with credentials name
  
  access control rules
    rule page *(*){true}