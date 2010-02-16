application test

  entity Bla {
    val :: String
  }
  
  var b1 := Bla { val := "oldvalue" }

  define page root(){
    "root page"
    action red(){
      return success();
    }    
    form{
      input(b1.val)
    }
    submit("save",red())
  }
  
  define page success(){
    output(b1.val)
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
    elist[1].sendKeys("new stuff");
    elist[2].click();
    
    assert(d.getPageSource().contains("redirected to success page"), "should have been redirected");
    assert(!d.getPageSource().contains("new stuff"), "input shouldnt have been included in action data binding");
    
    d.close();
  }
  

  