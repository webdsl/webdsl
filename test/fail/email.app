//No email definition for
application test

section datamodel

  define email testemail(us : User)
  {
    to(us.mail)
    from("admin@webdsl.org")
    subject("Email confirmation")
    par{ "Dear " output(us.name) ", " }
    par{
     "Please confirm the receipt of this message by visiting the following page "
     navigate(confirmEmail(us)){"confirm"}
    }
  }

  entity User{
    name :: String
    mail :: Email
  }

  define page root(){
    for(u:User)
    {
      output(u.name)
    }
    "test page"
    var u : User := User{
      name := "bob"
      mail := "webdsl@gmail.com"
    };
    form{
      input(u.name)
      input(u.mail)

      action("email",send())
    }
    action send()
    {
      email(testail(u));
      u.save();
    }

  }


  define page confirmEmail(u:User){

    output(u.name) " confirmed"
  }
