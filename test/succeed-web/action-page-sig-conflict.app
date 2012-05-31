application test

  define page root(){
    submit root(){"1"}
    action root(){
      return root();
    }
    submit action{ return root(); } {"2"}
    "foobarrootpage"
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[0].click();
    
    assert(d.getPageSource().contains("foobarrootpage"));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[1].click();

    assert(d.getPageSource().contains("foobarrootpage"));
  }
  