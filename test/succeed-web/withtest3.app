application withtest3

define page root() {
  ietsowner()  {
    "hello"
  }
}
    
define template helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break "> " hello(){ "foobar" } " <"
} 

define template ietsowner () {
  helloowner() with {
      hello() { 
        elements()
        //@TODO ietsowner.elements
      } 
  }
}

  test pagecontent{
    var d := HtmlUnitDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("foobar"));
    
    d.close();
  }
