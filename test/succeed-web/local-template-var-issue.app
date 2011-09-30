application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var i := "1"
    form{
      b()
      submit action{ TestEntity{ name := i }.save(); } {"save"}
    }
    
    for(t:TestEntity){
      output(t.name)
    }
    
    define b(){
      input(i)
    }
  }

  define b(){}

  test var {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected 3 <input> elements did not match");
    elist[1].sendKeys("23456789");
    elist[2].click();
    assert(d.getPageSource().contains("123456789"), "entered data not found");
  }
  
