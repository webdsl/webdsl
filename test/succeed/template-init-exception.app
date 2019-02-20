application test

entity E {
  e : E
  name : String
}

var e1 := E{}

page root(){
  testtemplate
}

template testtemplate(){
  "1"
  err
  "2"
  err2
  "3"
  err3
  "4"
  output(e1.e.e.name)
}

template err(){
  var e2 : Bool := npe()
  "error should not be visible"
}

// has ac rule with exception
template err2(){
  "error"
}

template err3(){
  init{
    npe();
  }
  "error"
}

test {
  var a := rendertemplate( testtemplate() );
  log( a );
  assert( a == "1234" );
}

principal is E with credentials name

function npe(): Bool{
  return e1.e.e == null;  // null pointer exception
}

access control rules
  rule page root(){ true }
  rule template err2(){ npe() }
