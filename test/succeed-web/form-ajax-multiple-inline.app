application test

page root(){
  var i := 0
  form{
    input( i )[ class="input1" ]
    submitlink action{ clear(err1); replace(p1); clear(err2); replace(p2); clear(err3); }{ "replace" }
  }
  placeholder p1{
    if( i > 0 ){
      "SUCCCESS"
    }
  }
  placeholder p2{
    if( i > 0 ){
      "CORRECT"
    }
  }
  placeholder err1{ "ERROR" }
  placeholder err2{ "ERROR" }
  placeholder err3{ "ERROR" }
}

test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  var i := d.findElement( SelectBy.className( "input1" ) );
  i.sendKeys( "1" );
  d.getSubmit().click();
  
  assert( d.getPageSource().contains( "SUCCCESS" ) );
  assert( d.getPageSource().contains( "CORRECT" ) );
  assert( ! d.getPageSource().contains( "ERROR" ) );
}



