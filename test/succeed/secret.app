application test

section datamodel

  entity User{
    username :: String
    password :: Secret
  }

  var bob : User := User { username := "Bob" };

  define page root(){
    output(bob.username)
    output(bob.password)

    form{
      input(bob.username)
      input(bob.password)
      action("save",save())
    }
    action save()
    {
      bob.save();
    }
  }

  test secretFunctions {
    var s1 : Secret := "12345";
    s1 := s1.digest();
    assert(s1.check("12345" as Secret));
    assert(!s1.check("123" as Secret));

    assert(("1235" as Secret).digest().check("1235" as Secret));
  }

  test docExample {
    var s : Secret := "123";
    s := s.digest();
    assert(s.check("123" as Secret));
  }


  test defaultValue{
    var s : Secret;
    assert(s == "");
  }


  test stringfunctions{

    var s1 : Secret := "12345";

    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));

    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : Secret := "12";
    var s3 : Secret := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);

    var s4 : Secret := "550e8400-e29b-41d4-a716-446655440000";

    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as Secret).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase
    assert(("SDFEWRGDBTG123" as Secret).toLowerCase() as Secret == "sdfewrgdbtg123" as Secret);

    //split
    assert(("34gDE" as Secret).split() == ["3","4","g","D","E"]);
    assert(("34gDE" as Secret).split().concat() == "34gDE");
    assert(("34gDE" as Secret).split().concat(", ") == "3, 4, g, D, E");

    assert(("34gDE" as Secret).split("4").concat("4") == "34gDE");
    assert(("ery54h-tyjfu-kfyj-u" as Secret).split("-").length == 4);
    assert(("tfhfg6tyhj" as Secret).split().concat("-") == "t-f-h-f-g-6-t-y-h-j");
  }

  test callStringArg{
    test("4343trg" as Secret);
  }

  function test(s:Secret){}
