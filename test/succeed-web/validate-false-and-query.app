application canceltest

  entity SomeEnt {
    t :: Text
  }

  var globalent := SomeEnt{ t := "testvalue" }

  define page root() {
    var s := globalent

    form {
      input(s.t)
      
      qu // query causes flush
      submit("Save", action{ validate(false,""); })
    }
    
    output(s.t)
  }
  
  define qu(){
    var a := from SomeEnt;
  }

  test cancelfunc {
    var d : WebDriver := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("testvalue"), "'testvalue' on initial page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    var size := elist.length;
    assert(size==2,"expected 2 input elements");
    elist[0].sendKeys("1");
    elist[1].click();
    
    assert(d.getPageSource().contains("testvalue"), "'testvalue' not shown on next page, flush should have been reverted the output value due to validate fail");  
  }