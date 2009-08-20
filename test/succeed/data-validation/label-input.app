application labelinput

  entity User {
    name :: String (validate(name.length() > 2,"Name should be longer than 2 characters."))
    age :: Int (validate(age >= 0,"Age cannot be a negative number."))
  }
  
  define page root() {
    for(us:User){
      output(us.name)
      output(us.age)
    }
    
    var u := User { name := "bob" }
    form {
      label("Username") { nameinput(u) }
      ageinput(u)
      action("save",save())
    }
    action save(){
      u.save();
    }
  }

  define nameinput(user:User) {
    input(user.name)
  }

  define ageinput(user:User) {
    label("Age"){input(user.age)}
  }
  
  
