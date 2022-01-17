application test

page root {
  dark

  request var s1 := "123"
  request var s2: String := "123"
  request var s3: String

  submitlink action{
    s1 := "456";  // in code generator this was passed as a copy, should be ref
    s2 := "789";
    s3 := "10";
    replace( ph );
  }{ "refresh broken 1" }

  submitlink testcall() { "refresh broken" }
  action testcall(){
    s1 := "456";  // in code generator this was passed as a copy, should be ref
    s2 := "789";
    s3 := "10";
    replace( ph );
  }

  workaround( s1, ph )

  placeholder ph {
    "result: "
    ~s1
    ~s2
    ~s3
  }
}

template workaround( s: ref String, ph: Placeholder ){
  submitlink action{
    s := "456";  // because s is already a ref arg when passed to this template, this works
    replace( ph );
  }{ "refresh workaround" }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( "result: 123123" ) );
  d.getSubmits()[ 0 ].click();
  assert( d.getPageSource().contains( "result: 45678910" ) );
  d.getSubmits()[ 2 ].click();
  assert( d.getPageSource().contains( "result: 456123" ) );
  d.getSubmits()[ 1 ].click();
  assert( d.getPageSource().contains( "result: 45678910" ) );
}



template dark{ <style>body { background-color: black; color: silver; }</style> }
