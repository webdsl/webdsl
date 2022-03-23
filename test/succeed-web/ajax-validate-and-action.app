application test

request var checkmsg := "should still be visible after validation from inputajax"

page root {
  request var i1 := 0
  form {
    inputajax( i1 )[ class = "input1", oninput = action{ replace( ph ); } ]
    placeholder ph {
      if( i1 == 0 ){ ~checkmsg }
    }
  }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( checkmsg ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "foo" );
  sleep( 2000 );
  assert( d.getPageSource().contains( checkmsg ) );
}
