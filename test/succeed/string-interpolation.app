application test

page root() {
  testtemplate
}

entity Tmp {
  name : String
  i : Int
  function get(): String {
    return name;
  }
}

var t1 := Tmp { name := "t1" i := 1 }

template testtemplate() {
  "[no-interp]"
  "~t1.name"
  "bla~(t1.name).foo"
  "~t1.i\~escape\\\\\~"
  
  output( "[no-interp]" )
  output( "~t1.name" )
  output( "bla~(t1.name).foo" )
  output( "~t1.i\~" )
  
  ~t1.name
  ~(t1.name)
  ~t1.i
}

test {
  log( rendertemplate( testtemplate() ));
  assert( rendertemplate( testtemplate() ) == "[no-interp]t1blat1.foo1\~escape\\\\\~[no-interp]t1blat1.foo1\~t1t11" );
}

