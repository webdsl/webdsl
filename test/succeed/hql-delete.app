application crudpages

entity User {
  username : String (name)
}

init {
  var u_1 := User{ username := "test1" };
  u_1.save();
  u_1 := User{ username := "test2" };
  u_1.save();
  u_1 := User{ username := "test3" };
  u_1.save();
  u_1 := User{ username := "test4" };
  u_1.save();
  u_1 := User{ username := "test5" };
  u_1.save();
}

page root {
  form {
    submit action{ delete from User; }{ "delete" }
    output( "number of stored User entities: " + (from User).length )
  }
}

test {
  assert( (from User).length == 5 );
  delete from User;
  assert( (from User).length == 0 );
}
