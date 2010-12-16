application withtest2

define page root() {
  ietsowner() with {
    iets() {
      "hello"
    }
  }
}
    
define helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break "> " hello() " <"
} 

define ietsowner () requires iets() {
  helloowner() with {
      hello() { 
        iets() 
      } 
  }
}

  test pagecontent{
    var d := HtmlUnitDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("&gt; hello &lt;"));
    
    d.close();
  }
