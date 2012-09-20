application test

  define page root(){}
  
  enum Policy {
    open     ("Open"),
    moderated ("Moderated"),
    invitation ("By Invitation")
  }
  
  test {
    assert(open.name == "Open");
    assert(open != moderated);
    assert(open.name == test(open));
    assert((from Policy).length == 3);
  }
  
  function test(a:Policy):String{
    return a.name;
  }