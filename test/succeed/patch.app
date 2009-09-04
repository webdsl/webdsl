application test

  entity Test {
    prop :: Patch
  }
  
  var t_1 := Test{};

  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)
      action("save",action{})
    }
  }

  test patchFunctions {
    var s1 : Patch := "12345".makePatch("24");
    assert(s1.applyPatch("12345") == "24");

    var s2 : Patch := "23".makePatch("12345");
    assert(s2.applyPatch("23") == "12345");

    for(s:String in "1234".diff("123")){
      assert(s == "removed: 4");
    }
    
  }
   
  test defaultValue{
    var s : Patch;
    assert(s == "");
  }
  
  test stringfunctions{ 
  
    var s1 : Patch := "12345";
  
    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));
        
    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : Patch := "12";
    var s3 : Patch := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);
    
    var s4 : Patch := "550e8400-e29b-41d4-a716-446655440000";
    
    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as Patch).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase    
    assert(("SDFEWRGDBTG123" as Patch).toLowerCase() as Patch == "sdfewrgdbtg123" as Patch);

    //explodeString
    assert(("34gDE" as Patch).explodeString() == ["3","4","g","D","E"]);
    assert(("34gDE" as Patch).explodeString().concat() == "34gDE");
    assert(("34gDE" as Patch).explodeString().concat(", ") == "3, 4, g, D, E");

  }
  
  test callStringArg{
    test("4343trg" as Patch);
  }
  
  function test(p:Patch){}
