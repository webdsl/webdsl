application test

  define page root(){
    submit root(){"1"}
    action root(){
      return root();
    }
    submit action{ return root(); } {"2"}
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[0].click();
    
    assert(!(d.getPageSource().contains("404")), "redirect may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[1].click();

    assert(!(d.getPageSource().contains("404")), "redirect may not produce a 404 error");

    d.close();
  }
  