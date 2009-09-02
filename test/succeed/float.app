application test

  define page root() {

  }

  test floatfunctions{ 
  
    //round
    assert(5.5.round() == 6);
    var f := 5.49;
    assert(f.round() == 5);
        
    //floor
    assert(76.999.floor() == 76);
    var fl := 34.547;
    assert(fl.floor() == 34);
    
    //ceil
    assert(76.001.ceil() == 77);
    var fl := 34.0000;
    assert(fl.ceil() == 34);
    
    //random
    var rand : Float := random();
    assert(rand >= 0.0);
    assert(rand <= 1.0);
   
  }
  
  test defaultValue{
    var i : Float;
    assert(i == 0.0);
    assert(i == 0f);
  }