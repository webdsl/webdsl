application test

  define page root(){
    "root page"
    placeholder test {}
    form{
      submit("click here", action{ replace(test,theform()); })[ajax]
    }
  }
  
  define ajax theform(){
    "ajax form inserted"
    var i := 12
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
  
  test{
    
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
   
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected <input> elements did not match");
    
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("ajax form inserted"));
    checkOutputShown(d);    
 
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist1.length == 3, "expected <input> elements did not match");

    elist1[1].sendKeys("45gdg"); // should case validation error, since this field is for Int
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("root page"), "root page should not be overridden by an ajax call validation error");
    assert(d.getPageSource().contains("Not a valid number"), "validation error did not show up");
    assert(!d.getPageSource().contains("redirected to success page"), "validation error should have prevented action execution");
    checkOutputShown(d);
  }
  

  