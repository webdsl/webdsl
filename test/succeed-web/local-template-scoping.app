application test

page root(){
  a
  b
}

template a(){
  template foo(){ // local override
    "ERROR"
  }
}

template b(){
  foo // should invoke global because local override is in other context
}

template foo(){
  "SUCCESS"
}
  
test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  assert(!d.getPageSource().contains("ERROR"));
  assert(d.getPageSource().contains("SUCCESS"));
}