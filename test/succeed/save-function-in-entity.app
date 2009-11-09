application test

  entity User {
    function bla(){
      save();
    }
  }
  
  define page root(){}
  
  test save {
    var u := User{};
    u.bla();
    flush();
    assert((from User).length == 1);
  
  }