application registerexample

  entity User {
    s -> StringContainer
    predicate test(){s.s.length() > 3}
  }
  
  entity StringContainer{
    s :: String
  }

  var testUser := User{ s := StringContainer{s:="12345"}  }
  
  define page root() {}
  
  test predicateinentity{
    assert(testUser.test());
  }
