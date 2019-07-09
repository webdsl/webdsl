application exampleapp

entity IntHolder {
  i : Int
}

var e1 := IntHolder{ i := 1 }
var e2 := IntHolder{ i := 2 }
var e3 := IntHolder{ i := 3 }

page root {
  //var i := 123
  form{
  //inp(i)
    inp(e1.i) //[class="in1"]
    inp(e2.i) //[class="in2"]
    inp(e3.i) //[class="in3"]
    submit action{}{ "save" }
  }
  output( e1.i )
  output( e2.i )
  output( e3.i )
}

/* inline modifier will force inlining */
inline template inp( i: ref Int ){
  //var tname := getTemplate().getUniqueId()
  //var req := getRequestParameter(tname)
  <input
    if( getPage().inLabelContext() ){
      id= getPage().getLabelString()
    }
    //name=tname
    name= getTemplate().getUniqueIdNoCache()
    if( getRequestParameter( getTemplate().getUniqueIdNoCache() ) != null ){
      value= getRequestParameter( getTemplate().getUniqueIdNoCache() )  // req
    }
    else{
      value= i
    }
    class= "inputInt " + attribute( "class" )
    all attributes except "class"
  />
  databind{
    log( "id " + getTemplate().getUniqueIdNoCache() );
    log( "db " + getRequestParameter( getTemplate().getUniqueIdNoCache() ) );
    if( getRequestParameter( getTemplate().getUniqueIdNoCache() ) != null ){
      i := getRequestParameter( getTemplate().getUniqueIdNoCache() ).parseInt();
    }
  }
}

inline template test( k: String ){
  output( k )
  "abc"
}

test entityreftemplates {
  var d : WebDriver := getFirefoxDriver();
  d.get( navigate(root() ) );
  var elems := d.findElements( SelectBy.tagName( "input" ) );
  elems[ 1 ].sendKeys( "1" );
  elems[ 2 ].sendKeys( "2" );
  elems[ 3 ].sendKeys( "3" );
  d.getSubmit().click();
  assert( d.getPageSource().contains( "112233" ) );
}

//inline
//current limitations:
//no local redefine
//no actions
// no inlining in for loop (because of vars)
