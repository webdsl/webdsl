application test

entity Tmp {
  s : String
  i : Int
}

var t1 := Tmp{ s := "t1" }
var t2 := Tmp{ s := "t2" }

page root {
  init{ "template id of root page ~(id)"; }
  submitlink action{ replace( ph1, showUniqueId( t1 ) ); }[ class="link" ]{ "link1" }
  submitlink action{ replace( ph2, showUniqueId( t2 ) ); }[ class="link" ]{ "link2" }

  placeholder ph1{}
  placeholder ph2{}
  placeholder ph3 submitTest( ph3, t3 )
  placeholder ph4 submitTest( ph4, t4 )
}

ajax template showUniqueId( t: Tmp ){
  init{ "template id of showUniqueId template ~(id)"; }
  var tplid := id
  span[ id=t.s ]{
    ~tplid
  }
}

var t3 := Tmp{}
var t4 := Tmp{}

ajax template submitTest( ph: Placeholder, t: Tmp ) {
  init{ "template id of submitTest template ~(id)"; }
  ~t.i
  form {
    input( t.i )[ class="testinput" ]
    submitlink action{
      replace( ph, submitTest( ph, t ) );
    }{ "save" }
  }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  for( elem in d.getSubmits() ){
    elem.click();
  }
  var id1 := d.findElement( SelectBy.id( "t1" ) ).getText();
  var id2 := d.findElement( SelectBy.id( "t2" ) ).getText();
  assert( id1 != id2, "Call to 'id' should be different for ajax loaded templates that have different arguments" );

  var inputElem := d.findElement( SelectBy.className( "testinput" ) );
  inputElem.sendKeys( "424242" );
  d.getSubmits()[ 2 ].click();
  assert( d.getPageSource().contains( "424242" ) );

  var inputElem2 := d.findElements( SelectBy.className( "testinput" ) )[1];
  inputElem2.sendKeys( "abc" );
  d.getSubmits()[ 3 ].click();
  assert( d.getPageSource().contains( "valid number" ) );  // should show validation error in second form
  assert( d.getPageSource().contains( "424242" ) );

  var inputElem3 := d.findElements( SelectBy.className( "testinput" ) )[1];
  inputElem3.clear();
  inputElem3.sendKeys( "98765" );
  d.getSubmits()[ 3 ].click();
  assert( d.getPageSource().contains( "98765" ) );
  assert( d.getPageSource().contains( "424242" ) );
  assert( ! d.getPageSource().contains( "valid number" ) );

  d.findElement( SelectBy.className( "testinput" ) ).sendKeys( "abc" );
  d.getSubmits()[ 2 ].click();
  assert( d.getPageSource().contains( "valid number" ) );
  d.getSubmits()[ 3 ].click();
  assert( d.getPageSource().contains( "valid number" ) );  // error from other form should not be replaced

}
