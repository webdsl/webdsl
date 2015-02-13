application test

  define page root() {

  }

  test { 
  
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
    var fl1 := 34.0000;
    assert(fl1.ceil() == 34);
    
    //random
    var rand : Float := random();
    assert(rand >= 0.0);
    assert(rand <= 1.0);
   
    // default value
    var i : Float;
    assert(i == 0.0);
    assert(i == 0f);
    
    // binary operators
    assert(7.3*3.13 == 22.849);
    assert(7.3/3.13 == 2.3322682);
    assert(7.3%3.13 == 1.04);
  }