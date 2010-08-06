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
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    var alist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    alist[0].click();
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("testvalue"), "'testvalue' on initial page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    var size := elist.length;
    assert(size==3,"expected 3 input elements");
    elist[1].sendKeys("1");
    elist[2].click();

    assert(d.getPageSource().contains("testvalue"), "'testvalue' not shown on next page, flush should have been reverted the output value due to validate fail");  
  }