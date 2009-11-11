application test

  entity EmailAddress{
    address :: Email
  }

  define page root(){
  }

  test emailFunctions {
    var s1 : Email := "12345";
    s1 := "";
    
    var e1 : EmailAddress := EmailAddress {};
    e1.address := "dfsgdsgsf@dfgdsffd.dfg";
    e1.save();

  }
   
  test defaultValue{
    var s : Email;
    assert(s == "");
  }
  
  test stringfunctions{ 
  
    var s1 : Email := "12345";
  
    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));
        
    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : Email := "12";
    var s3 : Email := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);
    
    var s4 : Email := "550e8400-e29b-41d4-a716-446655440000";
    
    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as Email).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase    
    assert(("SDFEWRGDBTG123" as Email).toLowerCase() as Email == "sdfewrgdbtg123" as Email);

    //split
    assert(("34gDE" as Email).split() == ["3","4","g","D","E"]);
    assert(("34gDE" as Email).split().concat() == "34gDE");
    assert(("34gDE" as Email).split().concat(", ") == "3, 4, g, D, E");

    assert(("34gDE" as Email).split("4").concat("4") == "34gDE");
    assert(("ery54h-tyjfu-kfyj-u" as Email).split("-").length == 4);
    assert(("tfhfg6tyhj" as Email).split().concat("-") == "t-f-h-f-g-6-t-y-h-j");
  }
  
  test callStringArg{
    test("4343trg" as Email);
  }
  
  function test(e:Email){}
