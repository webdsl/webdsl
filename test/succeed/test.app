application testapp

  entity User{
    s :: String
    i :: Int
    b :: Bool
    t :: Text
    u -> User
    
    
    function add(){
      s := s + "added";
    }
  }

  var u_1 := User { s:= "teststring" }

  define page root()
  {
    for(u:User){
      output(u.s)
      output(u.i)
      output(u.b)
      output(u.t)
      output(u.u.name)
    }
  }
  
  
  test ajjjjijohgfdrdd{
    u_1.add();
    assert(u_1.s == "teststringadded");
    assert(u_1.s != "egr5", "add failed");
    assert(u_1.s != "erteth64");
    assertEquals("1","1");
    assertEquals(1,1,"test failed in assertEquals");
    assertNotSame(1,2);
    assert(1 != 2, "message");
  }
  
  test bddyfkfykgkgluhlu{
    assert(1==1);
    assert(2 == 2, "message");
  }