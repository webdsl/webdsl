application test

//issue on yellowgrass: http://yellowgrass.org/issue/WebDSL/709
//Dec 2021: updated test for related issue: https://yellowgrass.org/issue/WebDSL/926 

page root {
  dark
  request var someString := "old"  // request var that does not get reset should cover use cases for dynamicform
  placeholder "MYPH" { showString( someString ) }
  inputTemplate( someString )
}

template inputTemplate( stringRef: ref String ){
  var i := ""
  form { input( i )[ onkeyup=update(), class="input1" ] }
  action update(){ stringRef := i; replace( "MYPH" ); }
}

template showString( str : String ){
  decorate[ class=if( str == "new" ) "new" else "old" ] { output( str ) }
  "plain: " output( str )
  //check for control flow caching
  if( str == "old" ){
    "found-old"
  }
}

template decorate {
  <h1 all attributes> "decorated: " elements </h1>
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  sleep( 2000 );
  assert( d.getPageSource().contains( "decorated: old" ) );
  assert( d.getPageSource().contains( "h1 class=\"old" ) );
  assert( d.getPageSource().contains( "found-old" ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "new" );
  sleep( 2000 );
  assert( d.getPageSource().contains( "decorated: new" ) );
  assert( d.getPageSource().contains( "h1 class=\"new" ) );
  assert( ! d.getPageSource().contains( "found-old" ) );
  log( d.getPageSource() );
}


template dark{ <style>body { background-color: black; color: silver; }</style> }
