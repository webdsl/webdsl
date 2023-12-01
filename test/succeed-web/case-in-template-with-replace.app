application test

entity Store {
  choice : Choice
  testint1 : Int
  testint2 : Int
  i1 : Int
  i2 : Int
  i3 : Int
  s1 : String
  s2 : String
  s3 : String
  choice1 : Choice
  choice2 : Choice
}

enum Choice {
  choiceA ( "a" )
, choiceB ( "b" )
}

page root {
  var choice : Choice
  var testint1 := 0
  var testint2 := 0
  if( choice != choiceA ){  // control flow should cache, validation or action should not break when choiceA selected
    form {
      input( choice )[ class = "t1" ]
      input( testint1 )[ class = "i1" ]
      submit action{ message( "test 1 success" ); }{ "save" }
    }
  }
  case( choice ){  // control flow should cache, validation or action should not break when choiceA selected
    choiceA { }
    default {
      form {
        input( choice )[ class = "t2" ]
        input( testint2 )[ class = "i2" ]
        submit action{ message( "test 2 success" ); }{ "save" }
      }
    }
  }

  request var choice1: Choice  // request var changes behavior so control flow is allowed to change based on form input
  request var choice2: Choice
  var i1 := 0
  var i2 := 0
  var i3 := 0
  var s1 := ""
  var s2 := ""
  var s3 := ""
  action ignore-validation update {  // ignore validation of other form elements, e.g. arbitrary string in input( Int )
    replace( x );
  }
  form {
    input( choice1 )[ onclick = update(), class = "c1" ]
    input( choice2 )[ onclick = update(), class = "c2" ]
    placeholder x {
      if( choice1 == choiceA ){
        input( i1 )[ class = "if-i" ]
      }
      if( choice1 == choiceB ){
        input( s1 )[ class = "if-s" ]
      }
      // previously didn't work as expected, because a var is used in the desugaring of case which renders based on clean state
      case( choice1 ){
        choiceA { input( i2 )[ class = "case-i" ] }
        choiceB { input( s2 )[ class = "case-s" ] }
        default { "default" }
      }
      case( choice1, choice2  ){
        choiceA, choiceA { input( i3 )[ class = "case-i-2" ] }
        choiceB, choiceB { input( s3 )[ class = "case-s-2" ] }
        default { "default" }
      }
    }
    submit action {
      Store {
        i1 := i1
        i2 := i2
        i3 := i3
        s1 := s1
        s2 := s2
        s3 := s3
        choice1 := choice1
        choice2 := choice2
      }.save();
    }{ "save" }
  }
  div{ "stored: " }
  table {
    for( st: Store order by st.created desc limit 1 ){
      "~st.i1 ~st.i2 ~st.i3 ~st.s1 ~st.s2 ~st.s3 ~st.choice1.name ~st.choice2.name"
    }
  }
}


// variation with transient entity as request var

page test2 {
  var stvar := Store{}  // regular 'var' test, not 'request var'
  if( stvar.choice != choiceA ){  // control flow should cache, validation or action should not break when choiceA selected
    form {
      input( stvar.choice )[ class = "t1" ]
      input( stvar.testint1 )[ class = "i1" ]
      submit action{ message( "test 1 success" ); }{ "save" }
    }
  }
  case( stvar.choice ){  // control flow should cache, validation or action should not break when choiceA selected
    choiceA { }
    default {
      form {
        input( stvar.choice )[ class = "t2" ]
        input( stvar.testint2 )[ class = "i2" ]
        submit action{ message( "test 2 success" ); }{ "save" }
      }
    }
  }

  request var store := Store{}  // transient entity, 'request var' skips re-init of var in render phase, so it does not override entered form data before rendering

  action ignore-validation update {  // ignore validation of other form elements, e.g. arbitrary string in input( Int )
    replace( x );
  }
  form {
    input( store.choice1 )[ onclick = update(), class = "c1" ]
    input( store.choice2 )[ onclick = update(), class = "c2" ]
    placeholder x {
      if( store.choice1 == choiceA ){
        input( store.i1 )[ class = "if-i" ]
      }
      if( store.choice1 == choiceB ){
        input( store.s1 )[ class = "if-s" ]
      }
      case( store.choice1 ){
        choiceA { input( store.i2 )[ class = "case-i" ] }
        choiceB { input( store.s2 )[ class = "case-s" ] }
        default { "default" }
      }
      case( store.choice1, store.choice2  ){
        choiceA, choiceA { input( store.i3 )[ class = "case-i-2" ] }
        choiceB, choiceB { input( store.s3 )[ class = "case-s-2" ] }
        default { "default" }
      }
    }
    submit action {
      store.save();
    }{ "save" }
  }
  div{ "stored: " }
  table {
    for( st: Store order by st.created desc limit 1 ){
      "~st.i1 ~st.i2 ~st.i3 ~st.s1 ~st.s2 ~st.s3 ~st.choice1.name ~st.choice2.name"
    }
  }
}


// variation with persisted entity as request var
var globalstore := Store{}

page test3 {
  var stvar := globalstore  // regular 'var' test, not 'request var'
  if( stvar.choice != choiceA ){  // control flow should cache, validation or action should not break when choiceA selected
    form {
      input( stvar.choice )[ class = "t1" ]
      input( stvar.testint1 )[ class = "i1" ]
      submit action{ globalstore.choice := null; message( "test 1 success" ); }{ "save" }
    }
  }
  case( stvar.choice ){  // control flow should cache, validation or action should not break when choiceA selected
    choiceA { }
    default {
      form {
        input( stvar.choice )[ class = "t2" ]
        input( stvar.testint2 )[ class = "i2" ]
        submit action{ globalstore.choice := null; message( "test 2 success" ); }{ "save" }
      }
    }
  }

  /*request*/ var store := globalstore  // persisted entity reference, 'request var' or 'var' both work, because re-evaluating expression 'globalstore' results in same entity instance

  action ignore-validation update {  // ignore validation of other form elements, e.g. arbitrary string in input( Int )
    replace( x );
  }
  form {
    input( store.choice1 )[ onclick = update(), class = "c1" ]
    input( store.choice2 )[ onclick = update(), class = "c2" ]
    placeholder x {
      if( store.choice1 == choiceA ){
        input( store.i1 )[ class = "if-i" ]
      }
      if( store.choice1 == choiceB ){
        input( store.s1 )[ class = "if-s" ]
      }
      case( store.choice1 ){
        choiceA { input( store.i2 )[ class = "case-i" ] }
        choiceB { input( store.s2 )[ class = "case-s" ] }
        default { "default" }
      }
      case( store.choice1, store.choice2  ){
        choiceA, choiceA { input( store.i3 )[ class = "case-i-2" ] }
        choiceB, choiceB { input( store.s3 )[ class = "case-s-2" ] }
        default { "default" }
      }
    }
    submit action {
      // store.save();  // already persisted
    }{ "save" }
  }
  div{ "stored: " }
  table {
    for( st: Store in [ globalstore ] ){
      "~st.i1 ~st.i2 ~st.i3 ~st.s1 ~st.s2 ~st.s3 ~st.choice1.name ~st.choice2.name"
    }
  }
}



// test code

request var driver: WebDriver

test {
  driver := getFirefoxDriver();
  driver.get( navigate( root() ) );
  testpage();
  driver.get( navigate( test2() ) );
  testpage();
  driver.get( navigate( test3() ) );
  testpage();
}

// same test code for variants of request var
function testpage {
  selectVisibleText( "t1", "a" );
  setText( "i1", "abc" );
  submit( 0 );
  contains( "Not a valid number" );
  setText( "i1", "0" );
  submit( 0 );
  contains( "test 1 success" );

  selectVisibleText( "t2", "a" );
  setText( "i2", "abc" );
  submit( 1 );
  contains( "Not a valid number" );
  setText( "i2", "0" );
  submit( 1 );
  contains( "test 2 success" );
  notcontains( "Not a valid number" );

  selectVisibleText( "c1", "a" );
  setText( "if-i", "abc" );
  setText( "case-i", "22" );
  submit( 2 );
  contains( "Not a valid number" );
  selectVisibleText( "c1", "b" );
  notcontains( "Not a valid number" );

  selectVisibleText( "c1", "a" );
  selectVisibleText( "c2", "a" );
  setText( "if-i", "11" );
  setText( "case-i", "22" );
  setText( "case-i-2", "33" );
  submit( 2 );
  contains( "11 22 33" );

  selectVisibleText( "c1", "b" );
  selectVisibleText( "c2", "b" );
  setText( "if-s", "aaa" );
  setText( "case-s", "bbb" );
  setText( "case-s-2", "ccc" );
  submit( 2 );
  contains( "aaa bbb ccc" );
}

request var wait: Int := 2000

function selectVisibleText( class: String, text: String ) {
  sleep( wait );
  Select( driver.findElement( SelectBy.className( class ) ) ).selectByVisibleText( text );
}

function setText( class: String, text: String ) {
  sleep( wait );
  var elem := driver.findElement( SelectBy.className( class ) );
  sleep( wait );
  elem.clear();
  sleep( wait );
  elem.sendKeys( text );
}

function submit( i: Int ){
  sleep( wait );
  driver.getSubmits()[ i ].click();
}

function contains( s: String ){
  sleep( wait );
  assert( driver.getPageSource().contains( s ) );
}

function notcontains( s: String ){
  sleep( wait );
  assert( ! driver.getPageSource().contains( s ) );
}
