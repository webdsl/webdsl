application test

section datamodel

  entity User{
    name :: String
    parent -> User
  }
  
  var u1 : User := User {name := "1"};
  var u2 : User := User {name := "2" parent := u1};
  var u3 : User := User {name := "3" parent := u2};
  
  define page root(){
    table{
      for(u:User){
        row{column{ 
        "user: "
        output(u.name)
        }}
        row{column{
        "parent: "
        output(u.parent.name) // parent is null for u1, should not break page
        }}
        row{column{
        "parent's parent: "
        output(u.parent.parent.name)
        }}
      }
    }
  }
