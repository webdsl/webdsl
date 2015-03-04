application test

  entity User {
    function bla(){
      save();
    }
    function testreturn(): User{
      return save();
    }
    function testdelete():User{
      return delete();
    }
  }
  
  define page root(){}
  
  test save {
    var u := User{};
    u.bla();
    assert((from User).length == 1);

    var u1 := User{};
    var x := u1.testreturn();
    assert((from User).length == 2);
    assert(x == u1);

    var y := u1.testdelete();
    log("deleted: " + y);
    assert((from User).length == 1);
    assert(u1 == y);
  }