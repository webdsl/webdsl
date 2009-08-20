application test

/**
 *  test cc, bcc, replyTo
 */

section datamodel

  define email testemail(us : User) {
    to(us.mail)
    cc(us.mail)
    bcc(us.mail)
    replyTo(us.mail)
    
    from("webdslorg@gmail.com")
    subject("Email confirmation")

    "test"
  }

  entity User {
    name :: String
    mail :: Email
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
  
