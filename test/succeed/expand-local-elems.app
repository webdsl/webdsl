application expandtest

page root {}

entity Foo {
  expand foo bar y to x {  // entity body declarations
    x: String
    xCache: String
    xInt: Int
  }
  function x {
    expand foo bar y to x {  // statements
      log( x );
      log( xCache );
      log( xInt );
    }
    case( "b" ){ expand a b c to x { "x" { log("x"); } } }
    typecase( this as t ){ expand Foo to x { x { log( t.bar ); } } }
  }
}

template test( f: Foo ) {
  expand foo bar y to x {  // template elements
    output( "x", f.x )
    output( "xCache", f.xCache )
    output( "xInt", f.xInt )
  }
  var list := [ expand q w e to x { "x" } ]  // list elems
  for( i in list ){ ~i }
  var set := { expand r t y to x { "x" } }  // set elems
  for( i in set ){ ~i }
  div[ expand u i o to x { x = "x" } ]    // template call attributes
  <div expand a s d to x { x = "x" } ></div>   // html element attributes
  t3( expand f g h to x { "x" } )  // template call args
  output( f3( expand j k l to x { "x" } ) )  // function call args
  testMultipleInt
  testMultipleFoo
  case( "b" ){ expand a b c to x { "x" { "x" } } }
  typecase( f as t ){ expand Foo to x { x { ~t.bar } } }
}

template t3( expand s1 s2 s3 to x { x: String } ){ expand s1 s2 s3 to x { ~x } }
function f3( expand s1 s2 s3 to x { x: String } ): String { return "~s1~s2~s3"; }


var globalFoo := Foo {
  expand foo bar y to x {  // object creation set properties
    x := "123"
    xCache := "456"
    xInt := 9
  }
}

test {
  var s := rendertemplate( test( globalFoo ) );
  log( s );
  assert( s.contains( "foo123fooCache456fooInt9bar123barCache456barInt9y123yCache456yInt9qwerty<div u=\"u\" i=\"i\" o=\"o\"></div><div a=\"a\" s=\"s\" d=\"d\"></div>fghjklIntStringFooBarb123" ) );
}

expand Int String to Type {
  template output( label: String, s: ref Type ){  // top-level elements
    output( label )
    output( s )
    elements
  }
}

expand
  Int String
  Foo Bar
  to Type1 Type2 {
  template testMultipleType1 {
    "Type1Type2"
  }
}
