application test

entity E {
  name : String
}

page root(){
  testtemplate
}

template testtemplate(){
  "123"
  denied
  "456"
}

template denied(){
  denied2( "", 1 )
  denied3
}

template denied2( s: String, i: Int ){
  <div></div>
}

template denied3(){
  <div></div>
}

test {
  var a := rendertemplate( testtemplate() );
  log( a );
  assert( a == "123456" );
}

principal is E with credentials name

access control rules
  rule page root(){ true }
  rule template denied(){ true }
  rule template denied2( a: String, i: Int ){ false }
  rule template denied3(){ false }
