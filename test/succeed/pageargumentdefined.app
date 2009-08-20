application test

section datamodel

  entity User{
    name :: String
  }

  entity User2{
    name :: String (id)
  }
  
  define page root(){
    var u:User := User{};
    var u1:User2 := User2{};
  
    navigate(viewUser(u,u1)) { "view" }
    
  }


  define page viewUser(u:User,u1:User2)
  {
     output(u.name)
     output(u1.name)
  }
