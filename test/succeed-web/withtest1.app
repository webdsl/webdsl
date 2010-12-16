application withtest1

define page root() {
  test("wereld") with {
    hello() {
      showHello()
    }
    world(s: String) {
      world(s+"2")
    }		
  }
}
    
define showHello() {
 "hallo"
}

define world(x: String) {
  output(x+"3")
}

define test (wereld: String) requires hello(), world(String) {
  "the 'hello' template should appear here"
  break "> " hello() " <"
  spacer
  "and 'world123' should be just below"
  break "> " world(wereld+"!") " <"
} 

  
  test pagecontent{
    var d := HtmlUnitDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("hallo"));
    assert(d.getPageSource().contains("wereld!"));
    
    d.close();
  }
