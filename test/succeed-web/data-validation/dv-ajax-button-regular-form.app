application test


  define page root(){
    "root page"
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      submit("save",red())[ajax]
    }
  }
  
  define page success(){
    "redirected to success page"
  }

  
  test one {
    
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");

    elist[1].sendKeys("45gdg"); // should case validation error, since this field is for Int
    elist[2].click();
    
    assert(d.getPageSource().contains("Not a valid number"), "validation error did not show up");
    assert(!d.getPageSource().contains("redirected to success page"), "validation error should have prevented action execution");
    
    d.close();
  }
  

  