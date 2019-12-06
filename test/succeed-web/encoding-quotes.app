application test

page test( facet: String ){
  dark
  var searchQuery := ""
  input( searchQuery )[ class="the-input", oninput=updateSearch() ]
  action updateSearch() {
    log( facet );
    replace( x );
  }
  placeholder x { <div class="output-page-arg"> output( facet ) </div> }
}

page root() {
  dark
  navigate test( "a&db&c<>'\"" ){ "test page" }
  var i := getString()
  var searcher := PersonSearcher().query( getString() )
  var tmp1 := ""
  var tmp2 := ""
  var tmp3 := ""
  var tmp4 := ""
  placeholder ph1 test( getString(), ph1 )
  placeholder ph2 t( searcher, ph2 )
  form {
    input( i )[ class="the-input" ]
    submit action{ replace( ph1, test( i, ph1 ) ); }[ ajax, class="button-1" ]{ "replace-root" }
    submit action{ replace( ph2, t( searcher, ph2 ) ); }[ ajax, class="button-2" ]{ "replace-root-searcher" }
    inputajax( tmp1 )[ class="button-3", oninput=action{ replace( ph1, test( i, ph1 ) ); } ]
    inputajax( tmp2 )[ class="button-4", oninput=action{ replace( ph2, t( searcher, ph2 ) ); } ]
    input( tmp3 )[ class="button-5", oninput=action{ replace( ph1, test( i, ph1 ) ); } ]
    input( tmp4 )[ class="button-6", oninput=action{ replace( ph2, t( searcher, ph2 ) ); } ]
  }
}

ajax template test( a: String, tmp: Placeholder ){
  <div class="the-output-ajax-string-arg">
    output( "the string: " + a )
  </div>
  form {
    submit action{ replace( tmp, test( a, tmp ) ); }[ class="button-7" ]{ "replace-ajax-template" }
  }
}

entity Person {
  name : String
  search mapping {
    name;
  }
}

ajax template t( ps: PersonSearcher, tmp: Placeholder ){
  <div class="the-output-ajax-searcher-arg">
    output( "the string: " + ps.getQuery() )
  </div>
  form {
    submit action{ replace( tmp, t( ps, tmp ) ); }[ class="button-8" ]{ "replace-ajax-template-searcher" }
  }
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  checkit( d );
  for( i in [7,8,1,2] ){
    d.findElement( SelectBy.className( "button-" + i ) ).click();
    checkit( d );
  }
  for( i in [3,4,5,6] ){
    d.findElement( SelectBy.className( "button-" + i ) ).sendKeys( getString() );
    sleep( 1000 );  // test runner does not wait for delayed oninput
    checkit( d );
  }
  for( i in [7,8] ){
    d.findElement( SelectBy.className( "button-" + i ) ).click();
    checkit( d );
  }

  d.get( navigate( test( smallTest() ) ) );
  log( d.getPageSource() );
  assert( d.getPageSource().contains( smallOutput() ) );
  d.findElement( SelectBy.className("the-input" ) ).sendKeys("abcdef");
  sleep( 2000 );  // need to sleep for keyupdelay to pass, made it large enough to see the result while running
  assert( d.getPageSource().contains( smallOutput() ) );
}

native class utils.HTMLFilter as HTMLFilter {
  static filter( String ): String
}

function checkit( d: WebDriver ){
 assert(
   d.findElement(
     SelectBy.className( "the-output-ajax-string-arg" )
   )
  .getText()
  .contains( "the string: " +  getString() ) );
 assert(
   d.findElement(
     SelectBy.className( "the-output-ajax-searcher-arg" )
   )
  .getText()
  .contains( "the string: " +  getString() ) );
}

function getString(): String {
//  return "\\\"|\\'\\'>\\\\\\<><>?/,,./\"\"\"'./ '\"'\"```\~ \~\~\~`&quot;&amp;";
  return "\\\"|\\'\\'>\\\\\\<><>?/,,./\"\"\"'./ '\"'\"````&quot;&amp;";  // for comparing with older webdsl before string interpolation with '~'
}

function smallTest(): String {
  return "a&db&c<>'\"";
}

function smallOutput(): String {
  return "<div class=\"output-page-arg\">a&amp;db&amp;c&lt;&gt;'\"</div>";
}                                      //a&amp;db&amp;c&lt;&gt;\';

template dark() { <style>body { background-color: black; color: silver; }</style> }
