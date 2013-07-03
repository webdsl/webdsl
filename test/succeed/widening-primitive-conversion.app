application test

  page root(){}

  test {
    var then : Long := 60000L;
    var now : Int := 120000;
    var interval : Long := (now - then) / 60000L;
    assert( interval == 1);
    assert(interval < 2);
    assert(interval <= 2);
    interval := 1 + interval*60 / 2L % 2 - 5;
    assert(interval == -4);
    assert(interval > -5);
    assert(interval >= -4);
    assert(interval != 5);
  }