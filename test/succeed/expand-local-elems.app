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

}

template t3( s1: String, s2: String, s3: String ){ ~s1 ~s2 ~s3 }
function f3( s1: String, s2: String, s3: String ): String { return "~s1~s2~s3"; }


var f := Foo {
  expand foo bar y to x {  // object creation set properties
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

expand Int String to Type {
  template output( label: String, s: ref Type ){  // top-level elements
    output( label )
    output( s )
    elements
  }
}
