application derivetest

page root {}

entity Foo {
  derive x in foo bar y {  // entity body declarations
    x: String
    xCache: String
    xInt: Int
  }
  function x {
    derive x in foo bar y {  // statements
      log( x );
      log( xCache );
      log( xInt );
    }
  }
}

template test( f: Foo ) {
  derive x in foo bar y {  // template elements
    output( "x", f.x )
    output( "xCache", f.xCache )
    output( "xInt", f.xInt )
  }
  var list := [ derive x in q w e { "x" } ]  // list elems
  for( i in list ){ ~i }
  var set := { derive x in r t y { "x" } }  // set elems
  for( i in set ){ ~i }
  div[ derive x in u i o { x = "x" } ]    // template call attributes
  <div derive x in a s d { x = "x" } ></div>   // html element attributes
  t3( derive x in f g h { "x" } )  // template call args
  output( f3( derive x in j k l { "x" } ) )  // function call args

}

template t3( s1: String, s2: String, s3: String ){ ~s1 ~s2 ~s3 }
function f3( s1: String, s2: String, s3: String ): String { return "~s1~s2~s3"; }


var f := Foo {
  derive x in foo bar y {  // object creation set properties
    x := "123"
    xCache := "456"
    xInt := 9
  }
}

test {
  var s := rendertemplate( test( f ) );
  log( s );
  assert( s.contains( "foo123fooCache456fooInt9bar123barCache456barInt9y123yCache456yInt9qwerty<div u=\"u\" i=\"i\" o=\"o\"></div><div a=\"a\" s=\"s\" d=\"d\"></div>fghjkl" ) );
}

derive Type in Int String {
  template output( label: String, s: ref Type ){  // top-level elements
    output( label )
    output( s )
    elements
  }
}
