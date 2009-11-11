application text

  entity TextHolder{
    text :: Text
  }

  define page root(){
  }

  test textFunctions {
  
    var s1 : Text := "12345";
    s1 := "";
    
    var e1 := TextHolder{};
    e1.text := "dfsgdsgsf@dfgdsffd.dfg";
    e1.save();

  }
   
  test defaultValue{
    var s : Text;
    assert(s == "");
  }
  
  test stringfunctions{ 
  
    var s1 : Text := "12345";
  
    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));
        
    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : Text := "12";
    var s3 : Text := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);
    
    var s4 : Text := "550e8400-e29b-41d4-a716-446655440000";
    
    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as Text).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase    
    assert(("SDFEWRGDBTG123" as Text).toLowerCase() as Text == "sdfewrgdbtg123" as Text);

    //split
    assert(("34gDE" as Text).split() == ["3","4","g","D","E"]);
    assert(("34gDE" as Text).split().concat() == "34gDE");
    assert(("34gDE" as Text).split().concat(", ") == "3, 4, g, D, E");

    assert(("34gDE" as Text).split("4").concat("4") == "34gDE");
    assert(("ery54h-tyjfu-kfyj-u" as Text).split("-").length == 4);
    assert(("tfhfg6tyhj" as Text).split().concat("-") == "t-f-h-f-g-6-t-y-h-j");
  }
  
  test callStringArg{
    test("4343trg" as Text);
  }
  
  function test(e:Text){}
