application test

  entity Two {
    prop :: Int
  }

  define page root(){
    "root page"
    form{
      submit("ajaxsave2", 
        action{ 
        var two:=Two{prop := 1}; 
        two.save();
        replace(pl, atemp(two)); 
        }
      )[ajax]
        
    }
    
    placeholder pl {}
  }
  
  define ajax atemp(two: Two){
    "ajax template"
    form{
      input(two.prop)
      submit("save",action{refresh();})[ajax]
    }
    submit("refresh",action{refresh();})[ajax]
  }
  
  test encodingstest {
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    elist[1].click();
    Thread.sleep(2000);
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    elist[4].sendKeys("45gdg"); // should case validation error, since this field is for Int
    elist[5].click();
    Thread.sleep(2000);
    assert(d.getPageSource().contains("Not a valid number"));
    
    d.close();
  }
   