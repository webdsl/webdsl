application test

  define page root() {

  }

  test intfunctions{ 
  
    //floatValue
    assert(12345.floatValue() == 12345.0);
    var i := 123;
    assert(i.floatValue() == 123.0);
        
    //toString
    assert(12345.toString() == "12345");
    assert(i.toString() == "123");
    
  }
  
  test defaultValue{
    var i : Int;
    assert(i == 0);
  }