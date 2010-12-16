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

    //split
    //List<String>: implodeString
    assert("34gDE".split() == ["3","4","g","D","E"]);
    assert("34gDE".split().concat() == "34gDE");
    assert("34gDE".split().concat(", ") == "3, 4, g, D, E");

    assert("34gDE".split("4").concat("4") == "34gDE");
    assert("ery54h-tyjfu-kfyj-u".split("-").length == 4);
    assert("tfhfg6tyhj".split().concat("-") == "t-f-h-f-g-6-t-y-h-j");
    
    infunction("12345");
    //debugging: log
  }
  
  function infunction(a:String){
    assert("12345".length() == a.length());
  }
  
  test defaultValue{
    var s : String;
    assert(s == "");
  }