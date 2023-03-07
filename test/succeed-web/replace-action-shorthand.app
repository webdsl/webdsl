application test

page root {
  request var i1 := 0
  request var i2 := 0
  request var i3 := 0
  form {
    input( i1 )[ oninput = replace( x1 ), class = "i1" ]
    input( i2 )[ oninput = replace( x1, x2 ), class = "i2" ]
    input( i3 )[ oninput = replace( [ x1, x2 ] ), class = "i3" ]
  }
  placeholder x1 {
    "first:"
    ~i1
    ~i2
    ~i3
  }
  placeholder x2 {
    "second:"
    ~i1
    ~i2
    ~i3
  }
}


// test code

request var driver: WebDriver

test {
  driver := getFirefoxDriver();
  driver.get( navigate( root() ) );

  setText( "i1", "1" );
  contains( "first:100" );
  contains( "second:000" );
  setText( "i2", "2" );
  contains( "first:120" );
  contains( "second:120" );
  setText( "i3", "3" );
  contains( "first:123" );
  contains( "second:123" );
}

function setText( class: String, text: String ) {
  var elem := driver.findElement( SelectBy.className( class ) );
  elem.clear();
  elem.sendKeys( text );
  sleep( 2000 );
}

function contains( s: String ){
  assert( driver.getPageSource().contains( s ) );
}
