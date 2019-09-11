application test

  entity User{
    name     :: String
    child-> User
    children -> Set<User>
  }

  entity UserSet{
    users -> Set<User>
  }
  
  derive crud User

  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  var uset:UserSet := UserSet{users:={u2,u3}};
  
  define page root(){ 
    "name: " 
    output(u.name)
    output(u.child)
    output(u.children)
    form{
      input(u.name)
      input(u.child, uset.users)[onchange = action{}]
      input(u.children, uset.users)[onchange = action{}]
    }
    
    break
    
    form{
      input(u.child)[onchange = action{}]
      input(u.children)[onchange = action{}]
    }
  }
