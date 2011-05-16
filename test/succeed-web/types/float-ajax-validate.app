application exampleapp

  entity Ent {
    i :: Float
    validate(i > 10f, "must be greater than 10")
  }
  
  var e1 := Ent{ i := 5f }
  
  define page root(){
    form{
      inputajax(e1.i)[style="width:400px;"]{
        validate(e1.i >20f, "must be greater than 20")
      }
      submit action{} {"save"}
    }
  }

  test floattemplate {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    var input := d.findElement(SelectBy.className("inputFloat"));
    input.clear();
    input.sendKeys("1");
    Thread.sleep(2000);
    assert(d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));
    input.sendKeys("5");
    Thread.sleep(2000);
    assert(!d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));
    input.sendKeys("8");
    Thread.sleep(2000);
    assert(!d.getPageSource().contains("must be greater than 10"));
    assert(!d.getPageSource().contains("must be greater than 20"));

    input.clear();
    input.sendKeys("1");
    var button := d.findElement(SelectBy.className("button"));
    button.click();
    assert(d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));

    assert(d.getPageSource().contains("400px;"));
    d.close();
  }
