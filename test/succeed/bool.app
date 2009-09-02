application test

  define page root() {

  }

  test boolfunctions{ 
  
    assert(true.toString() == "true");
    assert(false.toString() == "false");
    var b := true;
    assert(b == true);
    
  }
  
  test defaultValue{
    var b : Bool;
    assert(b == false);
  }