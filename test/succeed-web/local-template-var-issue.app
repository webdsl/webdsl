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
  
  page nestedCall(){
    tpl("")
  }
  
  
  template tpl(s : String){
    wrapper{
      tpl("t1"){
        " "
        wrapper {
          " "
          tpl("t2")
          tpl("t3")
        }
      }
      tpl("t4"){        
      }
    }
    
  }
  
  template wrapper(){
    var lastCalled := "nothing"     
    template tpl(s : String){
      output(s) "-" output(lastCalled) br
      render{ lastCalled := s; }
      elements
    }    
    elements
  }
  

  define b(){}

  test var {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected 2 <input> elements did not match");
    elist[1].sendKeys("23456789");
    d.getSubmit().click();
    assert(d.getPageSource().contains("123456789"), "entered data not found");
    
    d.get(navigate(nestedCall()));
    assert(d.getPageSource().contains("t1-nothing"), "there seems to be an issue with lookup of vars from the wrapping template in the local overridden template");
    assert(d.getPageSource().contains("t2-nothing"), "there seems to be an issue with lookup of vars from the wrapping template in the local overridden template");
    assert(d.getPageSource().contains("t3-t2"), "there seems to be an issue with lookup of vars from the wrapping template in the local overridden template");
    assert(d.getPageSource().contains("t4-t1"), "there seems to be an issue with lookup of vars from the wrapping template in the local overridden template");
  }
  
