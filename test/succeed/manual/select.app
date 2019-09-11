application exampleapp

entity User {
  username :: String (name)
  teammate -> User
  group -> Set<Group>
}
entity Group {
  groupname :: String (name)
}
init{
  var u := User { username := "Alice" };
  u.save();
  u := User { username := "Bob"};
  u.save();
  var g := Group { groupname := "group 1" };
  g.save();
  g := Group { groupname := "group 2" };
  g.save();
}

var u3 := User { username:="Dave" }
var g3 := Group { groupname:="group 3" }


define page root(){
  form{
    table{
      for(u:User){
        output(u.username)
        input(u.teammate)
        input(u.group)
      }
    }
    submit("save",action{})
  }
  
  var teammates := [u3];
  var groups := {g3};
  form{
    table{
      for(u:User){
        output(u.username)
        input(u.teammate, teammates)
        input(u.group, groups)
      }
    }
    submit("save",action{})
  }
  
  form{
    table{
      for(u: User2){
        output(u.username)
        input(u.teammate)
        input(u.group)
      }
    }
    submit("save",action{})
  }
  
  form{
    table{
      for(u:User){
        output(u.username)
        input(u.teammate)[not null]
        input(u.teammate, teammates)[not null]
        
      }
    }
    submit("save",action{})
  }
  
}

entity User2 {
  username :: String (name)
  teammate -> User (not null)
  group -> Set<Group> (allowed = [g3])
}
init{
  var u := User2 { username := "Charlie" };
  u.save();

}