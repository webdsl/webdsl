application test

section datamodel

  entity User{
    name :: String (default="1")
    test :: Text (default="2"+"3")
    ref -> User (default=gu1)
    list -> List<User> (default=[gu1])
    set -> Set<User> (default={gu1})
  }
  
  var gu1 := User{}
  
  define page root(){
  }

  test defaults{
    var u := User{ };
    assert(u.name == "1");
    assert(u.test == "23");
    assert(u.ref == gu1);
    assert(u.list[0] == gu1);
    assert(gu1 in u.set);
  }