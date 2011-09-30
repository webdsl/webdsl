application test

  entity Test {
    prop :: Date (format = "MM.dd.yyyy")
    prop1 :: Date
  }
  
  var t_1 := Test{ }  
  
  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)[class="input1"]
      action("save",action{})[class="button1"]
    }
    
    break
    
    output(t_1.prop1)
    form{
      input(t_1.prop1)[class="input2"]
      action("save",action{})[class="button2"]
    }
  }

  type Date { 
    format = "dd-MM-yyyy"
  }
  

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var input1 := d.findElement(SelectBy.className("input1"));
    input1.sendKeys("04.09.2010");
    var button1 := d.findElement(SelectBy.className("button1"));
    button1.click();    
    assert(d.getPageSource().contains("04.09.2010"), "first input failed");
    
    var input2 := d.findElement(SelectBy.className("input2"));
    input2.sendKeys("20-04-2010");
    var button2 := d.findElement(SelectBy.className("button2"));
    button2.click();    

    assert(d.getPageSource().contains("20-04-2010"), "second input failed");
  }
  

  