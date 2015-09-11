//http://yellowgrass.org/issue/WebDSL/575
application test

entity Blub{ 
  prop: String
}

template sometemplate(){
  var b: Blub := null
  form{
    validate( b.prop.length() > 0, "error message" )
    submit action{}[ class="btn" ]{ "do it" }
  }
}

page root(){
  sometemplate()
}
  
test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  var btn := d.findElement( SelectBy.className( "btn" ) );
  btn.click();
  var pagesource := d.getPageSource();
  assert( pagesource.contains( "error message" ), "error should show" );
}