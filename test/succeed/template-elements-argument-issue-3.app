application test

page root {
  wrapper
}

template wrapper {
  helper {
    "hey"
  }
}

template helper {
  labeledContent { 
    elemscall
  }
}

template labeledContent {
  var preventinline := 0  // required to fail, succeeds when this is removed
  elements
}

template elemscall {
  var preventinline := 0  // required to fail, succeeds when this is removed
  elements
}

test{
  var x := rendertemplate( wrapper() );
  log( x );
  assert( ! x.contains( "hey" ) );
}