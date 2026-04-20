application test

page root {}

entity TestEntity {
  name : String (id)
}

var globaltestent := TestEntity{ name := "123 \t ' \" \\ &" }

page testmore( targ: TestEntity ){
  placeholder ph testmoreajax( targ )
  nonajax
}

ajax template testmoreajax( targ: TestEntity ){
  form {
    placeholder xyz { }
    submitlink action { replace( xyz, msg( "submitlink 1 ok" ) ); }{ "link" }
    submit     action { replace( xyz, msg( "submit 2 ok" ) ); }{ "button" }
  }
}

ajax template msg( s: String ){ ~s }

template nonajax {
  form {
    submitlink action { return show( "submitlink 3 ok" ); }{ "link" }
    submit     action { return show( "submit 4 ok" ); }{ "button" }
  }
}
page show( s: String ){ ~s }

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( testmore( globaltestent ) ) );
  d.getSubmits()[ 0 ].click();
  sleep( 1000 );
  assert( d.getPageSource().contains( "submitlink 1 ok" ) );
  d.getSubmits()[ 1 ].click();
  sleep( 1000 );
  assert( d.getPageSource().contains( "submit 2 ok" ) );

  d.getSubmits()[ 2 ].click();
  assert( d.getPageSource().contains( "submitlink 3 ok" ) );
  d.get( navigate( testmore( globaltestent ) ) );
  d.getSubmits()[ 3 ].click();
  assert( d.getPageSource().contains( "submit 4 ok" ) );
}
