application test

page root {}

service testReturnService( condition1: String, condition2: String ){
  var res := "~condition1/~condition2/";
  if( condition1 == "true" ){
    if( condition2 == "true" ){
      return res + "1+2";
    }
    return res + "1";
  }
  if( condition2 == "true" ){
    return res + "2";
  }
  return res + "0";
}

test {
  driver := getFirefoxDriver();
  get( navigate( testReturnService( "true", "true" ) ) );
  contains( "true/true/1+2" );
  get( navigate( testReturnService( "true", "f" ) ) );
  contains( "true/f/1" );
  get( navigate( testReturnService( "f", "true" ) ) );
  contains( "f/true/2" );
  get( navigate( testReturnService( "f", "f" ) ) );
  contains( "f/f/0" );
}

request var driver: WebDriver

function get( url: String ){
  driver.get( url );
}

function contains( s: String ){
  assert( driver.getPageSource().contains( s ) );
}
