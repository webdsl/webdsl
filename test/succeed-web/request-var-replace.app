application test

page root {
  dark
  request var name := "default123"
  placeholder x {
    form {
      input( name )[ onkeyup=action{ replace( y ); }, class="input-1" ]
      placeholder y {
        "value: " ~name
      }
      submitlink action{ name := "replaced"; replace( x ); }{ "Save" }
    }
  }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( "value: default123" ) );
  var i := d.findElement( SelectBy.className( "input-1" ) );
  i.clear();
  i.sendKeys( "abc" );
  sleep( 1000 );  // test runner does not wait for delayed oninput
  assert( d.getPageSource().contains( "value: abc" ) );
  d.getSubmit().click();
  assert( d.getPageSource().contains( "value: replaced" ) );
}



template dark{ <style>body { background-color: black; color: silver; }</style> }
