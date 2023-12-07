application test

entity Course {
  title  : String (searchable)
  period : String (searchable) := getPeriod( title )

  // test facet with derived property
  function getPeriod( s: String ): String {
    if( s.length() > 12 ){ return "Q1"; }
    return "Q2";
  }
}

// creating entities in application init block does not trigger search reindex, using page init instead 
page initEntities {
  init {
    Course{ title := "x Algorithms" }.save();
    Course{ title := "x Data Structures" }.save();
    Course{ title := "x Web Database" }.save();
    Course{ title := "x AI LLM" }.save();
  }
}

page root {
  navigate initEntities { "init entities" }
  var s := (search Course with facets title(100), period(2)).query( "x" )
  for( f in s.getFacets( "title" ) ){
    div { ~f.getValue() ~f.getCount() }
  }
  for( f in s.getFacets( "period" ) ){
    div { ~f.getValue() ~f.getCount() }
  }
  for( r in s.results() ){
    div { ~r.title }
  }
}

// test code

test {
  driver := getFirefoxDriver();
  get( navigate( initEntities() ) );
  get( navigate( root() ) );
  contains( "x4" );
  contains( "ai1" );
  contains( "q12" );
  contains( "q22" );
}

request var driver: WebDriver

function get( url: String ){
  driver.get( url );
}

function contains( s: String ){
  assert( driver.getPageSource().contains( s ) );
}
