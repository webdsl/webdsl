application test

section datamodel

  entity User{
    key  :: String (id)
    name :: String (default="1")
    test :: Text (default="2"+"3")
    ref -> User (default=gu1)
    list -> List<User> (default=[gu1])
    set -> Set<User> (default={gu1})
  }
  
  var gu1 := User{ key:= "gu1" }
  
  define page root(){
  }

  test defaults{
    var u := User{ key:= "u" };
    assert(u.name == "1");
    assert(u.test == "23");
    assert(u.ref == gu1);
    assert(u.list[0] == gu1);
    assert(gu1 in u.set);
    var u2 := getUniqueUser("u2");
    assert(u2.name == "1");
    assert(u2.test == "23");
    assert(u2.ref == gu1);
    assert(u2.list[0] == gu1);
    assert(gu1 in u2.set);
  }