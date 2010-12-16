application withtest4

define page root() {
   helloowner() with {
      hello() { 
        "testhello" 
      } 
   }
}
    
define inarrows() {
  "> " elements() "< "
}    
    
define template helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break inarrows { hello() } //required template passed to elements() 
} 

  test pagecontent{
    var d := HtmlUnitDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("testhello"));
    
    d.close();
  }
