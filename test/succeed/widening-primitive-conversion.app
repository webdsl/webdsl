application test

  page root(){}

  test {
    var then : Long := 60000L;
    var now : Int := 120000;
    var interval : Long := (now - then) / 60000L;

    assert(interval == 1);
    assert(interval < 2);
    assert(interval <= 2);
    interval := 1 + interval*60 / 2L % 2 - 5;
    assert(interval == -4);
    assert(interval > -5);
    assert(interval >= -4);
    assert(interval != 5);
    
    var l : Long := 100L;
    var i : Int  := 100;
    
    assert( l == i );
    
    var d : Double := 3.0f - Double(2.0);
    var f : Float := 1.0f;
    assert(d == Double(1.0));
    assert(1.0f >= Double(1.0f));
    assert(1.0f <= Double(1.0f));
    assert(1.0f == Double(1.0f));
    assert(f >= d);
    assert(f <= d);
    assert(f == d);
    assert(f != Double(1.1));
    assert(Double(1.1) != f);
    assert(f < Double(2.0));
    assert(Double(2.0) > f);
    
  }