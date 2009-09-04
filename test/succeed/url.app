application test

  entity Test {
    prop :: URL
  }
  
  var t_1 := Test {};

  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)
      action("save",action{})
    }
  }

  test urlFunctions {
    var s1 : URL := url("wrefdgb");
    
  }
   
  test defaultValue{
    var s : URL;
    assert(s == "");
  }
  
  test stringfunctions{ 
  
    var s1 : URL := "12345";
  
    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));
        
    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : URL := "12";
    var s3 : URL := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);
    
    var s4 : URL := "550e8400-e29b-41d4-a716-446655440000";
    
    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as URL).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase    
    assert(("SDFEWRGDBTG123" as URL).toLowerCase() as URL == "sdfewrgdbtg123" as URL);

    //explodeString
    assert(("34gDE" as URL).explodeString() == ["3","4","g","D","E"]);
    assert(("34gDE" as URL).explodeString().concat() == "34gDE");
    assert(("34gDE" as URL).explodeString().concat(", ") == "3, 4, g, D, E");

  }
  
  test callStringArg{
    test("4343trg" as URL);
  }
  
  function test(p: URL){}
