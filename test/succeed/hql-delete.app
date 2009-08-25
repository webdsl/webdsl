application crudpages

  entity User {
    username    :: String (name)
  }
  init{
    var u_1 := User{username:= "test"};
    u_1.save();
    u_1 := User{username:= "test"};
    u_1.save();
    u_1 := User{username:= "test"};
    u_1.save();
    u_1 := User{username:= "test"};
    u_1.save();
    u_1 := User{username:= "test"};
    u_1.save();
  }
  define page root(){
    form{action("delete",action{delete from User;})}
    
    output("number of stored User entities: "+(from User).length)
  }
