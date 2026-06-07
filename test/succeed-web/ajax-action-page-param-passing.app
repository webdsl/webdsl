application test

page root {
  navigate testpage( globaltest ){ "go" }
}

entity TestEntity {
  name : String ( id )
  file : File
}

var globaltest := TestEntity { name := "abc" }

page testpage( arg123: TestEntity ){
  var i := 0
  var f : File

  input( i )[ oninput = action{ replace( showTrack ); }, class = "input1" ]

  placeholder showTrack {
    form {
      input( f )
      submit action{}{ "Save" }
    }
  }

  "correct page returned"
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( testpage( globaltest ) ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "42" );
  sleep( 1000 );
  d.getSubmits()[ 0 ].click();
  assert( d.getPageSource().contains( "correct page returned" ) );
}
