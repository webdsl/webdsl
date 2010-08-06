application canceltest

  entity SomeEnt {
    t :: Text
  }

  var globalent := SomeEnt{ t := "testvalue" }

  define page root() {
    var s := globalent
    output(s.t)
    form {
      submit("Save", action{ s.t := "123456"; flush(); validate(false,""); })
    }
  }

  test cancelfunc {
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("testvalue"), "'testvalue' on initial page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    var size := elist.length;
    assert(size==2,"expected 2 input elements");
    elist[1].click();

    assert(d.getPageSource().contains("testvalue"), "'testvalue' not shown on next page, flush should have been reverted the output value due to validate fail");  
  }