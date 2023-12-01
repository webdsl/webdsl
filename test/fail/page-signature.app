//There is no page with signature test(String)
application test

page root {
  navigate test( "a", "b" ){}
  navigate test( "a" ){}
}

page test( a: String, b: String ){}
