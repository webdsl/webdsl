application test

entity Tmp {
  b: Bool
}

var tmp1 := Tmp{}

page root {
  placeholder page {
    content( page )
  }
}

template content( page: Placeholder ){
  span[ style = if( tmp1.b ) "color:red;" else "" ]{ "123" }
  <span style = if( tmp1.b ) "color:red;" else ""> "456" </span>
  notinlined[ style = if( tmp1.b ) "color:red;" else "" ]{ "789" }
  submit action{
    tmp1.b := ! tmp1.b;
    replace(page);
  }{ "go" }
}

template notinlined {
  var x := 0  // add some arbitrary form input to avoid inlining of this template
  form {
    input( x )[ oninput = action{} ]
  }
  <span all attributes> elements </span>
}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( "<span>123</span>" ) );
  assert( d.getPageSource().contains( "<span>456</span>" ) );
  assert( d.getPageSource().contains( "<span>789</span>" ) );
  d.getSubmit().click();
  assert( d.getPageSource().contains( "<span style=\"color:red;\">123</span>" ) );
  assert( d.getPageSource().contains( "<span style=\"color:red;\">456</span>" ) );
  assert( d.getPageSource().contains( "<span style=\"color:red;\">789</span>" ) );
  d.getSubmit().click();
  assert( d.getPageSource().contains( "<span>123</span>" ) );
  assert( d.getPageSource().contains( "<span>456</span>" ) );
  assert( d.getPageSource().contains( "<span>789</span>" ) );
}
