application test

entity Letter {
  char : String (name)
}

var letterA := Letter{ char := "a" }


entity StoreResult {  // entity to capture problem situation which happens during init of template
  testrq : Bool ( default = true )
  testph : Bool ( default = true )
}
var store := StoreResult{}

page root {
  dark

  request var prefix := letterA

  init {
    if( prefix == null ){
      store.testrq := false;
    }
    log( "init request var: " + prefix );  // bug: request var was null during init

    if( ph == null ){
      store.testph := false;
    }
    log( "init placeholder: " + ph );  // bug: placeholder value was null during init
  }

  form {
    submitlink action{ log( "action: " + prefix );}{ "click" }
  }

  "prefix: ~prefix"
  "testrq: ~store.testrq"
  "testph: ~store.testph"

  placeholder ph { }

  submitlink action{ replace( ph ); }{ "refresh" }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  d.getSubmits()[ 0 ].click();
  d.getSubmits()[ 1 ].click();

  assert( d.getPageSource().contains( "testrq: true" ) );  // request var was null in init
  assert( d.getPageSource().contains( "testph: true" ) );  // placeholder value was null in init
}



template dark { <style>body { background-color: black; color: silver; }</style> }
