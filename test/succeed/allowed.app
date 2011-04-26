application test

  entity User {
    name    :: String
    ref1 -> User (allowed = [u1,u2]) //, not null)    
    ref2 -> User (allowed = [u2,u3]) //, not null)
    ref3 -> User (allowed = [u1,u3])
    ref4 -> Set<User> (allowed = [u1,u2])
    ref5 -> List<User> (allowed = [u2,u3])
    ref6 -> List<User> (allowed = ref5)
  }
  
  var u1 := User { name := "u1" }
  var u2 := User { name := "u2" }
  var u3 := User { name := "u3" }
  
  define page root()
  {
    for(u : User){
      output(u)
      navigate(editUser(u)){"edit"}
    }
  }
  
  derive crud User
