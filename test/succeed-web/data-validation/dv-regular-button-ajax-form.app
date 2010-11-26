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
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      submit("save",red())
    }
  }
  
  define page success(){
    "redirected to success page"
  }

  native class Thread{
    static sleep(Int)
  }

  
  test one {
    
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
   
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[1].click();
    
    //cannot continue right away, otherwise ajax might not be loaded
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("ajax form inserted"));
 
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected <input> elements did not match");

    elist[1].sendKeys("45gdg"); // should case validation error, since this field is for Int
    elist[2].click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("root page"), "root page should not be overridden by an ajax call validation error");
    assert(d.getPageSource().contains("Not a valid number"), "validation error did not show up");
    assert(!d.getPageSource().contains("redirected to success page"), "validation error should have prevented action execution");
    
    d.close();
  }
