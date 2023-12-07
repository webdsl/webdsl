application test

page root {}

template test {
  var i: Int
  var s: String
  init {
    i := 2;
  }
  init {
    s := "4";
  }
  ~s~i
}

test {
  assert( rendertemplate( test() ) == "42" );
}
