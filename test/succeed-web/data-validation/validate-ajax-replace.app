application test

  native class org.openqa.selenium.WebDriverBackedSelenium as WebDriverBackedSelenium {
    constructor(WebDriver, String)
    waitForCondition(String, String)
    stop()
  } 

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
    var s : WebDriverBackedSelenium := WebDriverBackedSelenium(d, navigate(root()));
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected <input> elements did not match");
    
    elist[1].click();
    s.waitForCondition("selenium.browserbot.getCurrentWindow().document.body.textContent.indexOf('ajax template') != -1", "5000");
    
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    elist[4].sendKeys("45gdg"); // should case validation error, since this field is for Int
    
    elist[5].click();
    s.waitForCondition("selenium.browserbot.getCurrentWindow().document.body.textContent.indexOf('Not a valid number') != -1", "5000");
    
    assert(d.getPageSource().contains("Not a valid number")); // Not needed, because the above line will throw an exception before this assert fails
    s.stop(); // also closes the WebDriver
    // d.close();
  }
   