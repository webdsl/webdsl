application test

  entity Test {
    prop :: Date (format = "mm.dd.yyyy")
    prop1 :: Date
  }
  
  var t_1 := Test{ }  
  
  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)
      action("save",action{})
    }
    
    break
    
    output(t_1.prop1)
    form{
      input(t_1.prop1)
      action("save",action{})
    }
  }

  type Date { 
    format = "dd-mm-yyyy"
  }
  

  test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected <input> elements did not match");
    elist[1].sendKeys("04.09.2010");
    elist[3].click();    
    assert(d.getPageSource().contains("04.09.2010"), "first input failed");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected <input> elements did not match");
    elist[5].sendKeys("20-04-2010");
    elist[7].click();    
    assert(d.getPageSource().contains("20-04-2010"), "second input failed");


    d.close();
  }
  

  