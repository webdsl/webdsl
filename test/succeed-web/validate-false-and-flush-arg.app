application canceltest

  entity SomeEnt {
    t :: Text
  }
  init{
    var e := SomeEnt{ t := "testvalue" };
    e.save();
  }
  define page root() {
    navigate edit((from SomeEnt)[0]){"go"}
  }
  
  define page edit(s:SomeEnt){
    
    
    output(s.t)
    
    form {
      input(s.t){
        validate(flushFalse(),"")
      }
      submit("Save", action{ })
    }
  }
  
  function flushFalse() : Bool{
    flush();
    return false;
  }

  test cancelfunc {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    var alist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    alist[0].click();
    assert(d.getPageSource().contains("testvalue"), "'testvalue' on initial page");
    var text : WebElement := d.findElement(SelectBy.tagName("textarea"));
    text.clear();
    text.sendKeys("1");
    var input : WebElement := d.findElements(SelectBy.tagName("input"))[2];
    input.click();
    
    assert(d.getPageSource().contains("testvalue"), "'testvalue' not shown on next page, flush should have been reverted the output value due to validate fail");
    
    d.close();  
  }