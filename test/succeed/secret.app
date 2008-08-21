application test

section datamodel

  entity User{
    username :: String
    password :: Secret
  }

  var bob : User := User { username := "Bob" };

  define page home(){
    output(bob.username)
    output(bob.password)
    
    form{
      input(bob.username)
      input(bob.password)
      action("save",save())
      action save()
      {
        bob.save();
      }
    }
  }