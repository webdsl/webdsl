application test

entity Book {
  title : String
}

page root {}

template show {
  var books := [ Book{ title := "1" }, Book{ title := "2" }, Book{ title := "3" } ]

  for( i in books ){
    ~i.title
  }
  for( i in books where i.title != "1" order by i.title desc ){
    ~i.title
  }
  "-"
  ~show( books )
}

function show( b: [Book] ): String {
  var r := "";
  for( x in b ){
    r := r + x.title;
  }
  for( x in b where x.title != "2" order by x.title asc ){
    r := r + x.title;
  }
  return r;
}

test {
  assert( rendertemplate( show() ).contains( "12332-12313" ) );
}

test forcountinferred {
  var x := 0;
  for( i from 0 to 5 ){ x := x + i; }
  assert( x == 10 );
  assert( [ for( j from 0 to 5 ){ "" + j*2 } ].concat() == "02468" );
  assert( rendertemplate( forcountinferred() ).contains( "123456789" + "0112233445" ) );
}

template forcountinferred {
  for( i from 0 to 10 ){
    ~i
  }
  elems( [ for( h from 0 to 10 ){ ( h, h+1 ) } ] )
}

template elems( list: [ first: Int, second: Int ] ){
  for( l in list ){ ~l.first ~l.second }
}
