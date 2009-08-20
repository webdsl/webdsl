application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    name     :: String
    children -> List<User>
    childrenset -> Set<User>
    self     -> User
  }
  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  
  define page root(){
    main()
    define body(){
    init{
      var u11:User := User{name := "alice" self := u1};
      var u22:User := User{name := "charlie" self := u2};
      var u33:User := User{name := "dave" self := u3};
      u.childrenset := {u1,u2};
      u.children := [fr.self for (fr : User in [u11,u22,u33])];
    }

    if(u1 in u.children)
    {
      "test ok"
    }
    else
    {
      "test fail"
    }
    
    output(u.children)
    "-"
    output(u.childrenset)
    }
  }
  
  define main(){
    body()
  }
  
  define page user(u:User){
    derive viewPage from u
  }
