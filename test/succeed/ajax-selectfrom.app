application test

section datamodel

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
      select(u.child from uset.users)
      select(u.children from uset.users)
      ac()
      actionLink("savelink")[onclick:=action{}]
    }
  }

  define ac(){
    action("save",save())
    action save()
    {
      refresh();
    }
  }