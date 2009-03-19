application formcheckseparate

  entity User {
    name :: String
  }
  
  define page home() {
    for(us:User){
      output(us.name)
    }
    
    var s :String := ""
    var s1 :String := ""
    var u := User { name := "bob" }
    form {
      validate(s == u.name,"Entered values differ.")
      formgroup("User"){   
        label("Username") { input(u.name) }
        label("Repeat Username") { input(s) }
        label("Repeat Username") { input(s1) {validate(s1 == u.name,"Not the same name.")} }
        action("save",save())
      }
    }
    action save(){
      u.save();
    }
  }
