application test

page root {
  dark

  request var boolOption : Bool

  init {
    if( boolOption == null ){ boolOption := false; }
  }

  placeholder ph {
    form {
      "bool option: "
       input( boolOption )[ class="bool-input" ]
       " "
       "bool output: ~boolOption"
       " "
       submitlink action{ replace( ph ); }{ "refresh form" }
     }
  }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( "bool output: false" ) );

  clickBool( d );
  assert( d.getPageSource().contains( "bool output: true" ) );

  clickBool( d );
  assert( d.getPageSource().contains( "bool output: false" ) );
}

function clickBool( d: WebDriver ){
  var boolElem := d.findElement( SelectBy.className( "bool-input" ) );
  boolElem.click();
  d.getSubmit().click();
}


template dark{ <style>body { background-color: black; color: silver; }</style> }
