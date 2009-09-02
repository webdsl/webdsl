application test


  define page root() {
    output("9993".parseInt() + 7)
    if("dgdfgfd".parseInt() == null){
      "ok"
    }
    else{
      "fail"
    }
  }

  test stringfunctions{ 
    //contains
    assert("12345".contains("3"));
    assert(!"12345".contains("8"));
        
    //length
    assert("12345".length() == 5);
    assert("12345".length() != 3);
    
    //parseInt
    assert("12".parseInt() == 12);
    assert("ggddgdfg".parseInt()==null);
    
    //parseUUID
    assert("550e8400-e29b-41d4-a716-446655440000".parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert("ggddgdfg".parseUUID()==null);

    //toUpperCase
    assert("sdfewrgdbtg123".toUpperCase() == "SDFEWRGDBTG123");

    //toLowerCase    
    assert("SDFEWRGDBTG123".toLowerCase() == "sdfewrgdbtg123");

    //explodeString
    //List<String>: implodeString
    assert("34gDE".explodeString() == ["3","4","g","D","E"]);
    assert("34gDE".explodeString().concat() == "34gDE");
    assert("34gDE".explodeString().concat(", ") == "3, 4, g, D, E");

    //debugging: log
  }
  
  test defaultValue{
    var s : String;
    assert(s == "");
  }