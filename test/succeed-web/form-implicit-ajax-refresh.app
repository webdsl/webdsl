application test

page root(){
  var tmp := ""
  form{
    input( tmp )[ class="input0" ]
  }
  var i := 0
  form{
    input( i )[ class="input1" ]
    submitlink action{}{ "save" }
  }
  submitlink action{ validate(false, "error-not-in-form"); }{ "save" }
  submit action{ validate(false, "error-button-not-in-form"); }{ "save" }
}

test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  var i0 := d.findElement( SelectBy.className( "input0" ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "a" );
  d.getSubmits()[ 0 ].click();
  assert( i0.isEnabled() );  // accessing WebElement fails if it was replaced in DOM
  assert( d.getPageSource().contains( "Not a valid number" ) );
  
  d.getSubmits()[ 1 ].click();
  assert( i0.isEnabled() );
  assert( d.getPageSource().contains( "Not a valid number" ) );
  assert( d.getPageSource().contains( "error-not-in-form" ) );
  
  d.getSubmits()[ 2 ].click();
  assert( i0.isEnabled() );
  assert( d.getPageSource().contains( "Not a valid number" ) );
  assert( d.getPageSource().contains( "error-not-in-form" ) );
  assert( d.getPageSource().contains( "error-button-not-in-form" ) );
}


page test2(){
  placeholder ph testajax
  var i := 0
  form{
    input( i )[ class="input1" ]
    submitlink action{}{ "save" }
  }
  submitlink action{ validate(false, "error-not-in-form"); }{ "save" }
  submit action{ validate(false, "error-button-not-in-form"); }{ "save" }
}

ajax template testajax(){
  var tmp := ""
  form{
    input( tmp )[ class="input0" ]
  }
}

test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( test2() ) );
  var i0 := d.findElement( SelectBy.className( "input0" ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "a" );
  d.getSubmits()[ 0 ].click();
  assert( i0.isEnabled() );  // accessing WebElement fails if it was replaced in DOM
  assert( d.getPageSource().contains( "Not a valid number" ) );
  
  d.getSubmits()[ 1 ].click();
  assert( i0.isEnabled() );
  assert( d.getPageSource().contains( "Not a valid number" ) );
  assert( d.getPageSource().contains( "error-not-in-form" ) );
  
  d.getSubmits()[ 2 ].click();
  assert( i0.isEnabled() );
  assert( d.getPageSource().contains( "Not a valid number" ) );
  assert( d.getPageSource().contains( "error-not-in-form" ) );
  assert( d.getPageSource().contains( "error-button-not-in-form" ) );
}
