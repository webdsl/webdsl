application test

  define page root(){}

  entity SomethingHappened {
    whatHappened :: String
  }
  
  define page home(){
    output(test())   
  }
  
  function test():String{
    try{
      log("try");
      bla();
    }
    catch(sh:SomethingHappened){
      log("catch");
      return "ok " + sh.whatHappened;
    }
    return "error";
  }  
  
  function bla(){
    throw SomethingHappened{ whatHappened := "an exception" };
  }
  
  test exc {
    assert(test()=="ok an exception");
  }