application test


  define page root(){
    "root page"
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      "output:" output(i)  // test that it shows persisted value, not entered value
      submit("save",red())[ajax]
    }
  }
  
  define page success(){
    "redirected to success page"
  }

  function checkOutputShown(d: WebDriver){
    assert(d.getPageSource().contains("output:1"));
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    checkOutputShown(d);
    
    elist[1].sendKeys("45gdg"); // should case validation error, since this field is for Int
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("Not a valid number"), "validation error did not show up");
    assert(!d.getPageSource().contains("redirected to success page"), "validation error should have prevented action execution");
    checkOutputShown(d);
  }
  

  