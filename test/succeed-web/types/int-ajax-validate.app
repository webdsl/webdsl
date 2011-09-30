application exampleapp

  entity Ent {
    i :: Int
    validate(i > 10, "must be greater than 10")
  }
  
  var e1 := Ent{i:= 15}
  
  define page root(){
    form{
      inputajax(e1.i)[style="width:400px;"]{
        validate(e1.i >20, "must be greater than 20")
      }
      submit action{} {"save"}
    }
  }

  test inttemplate {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var input := d.findElement(SelectBy.className("inputInt"));
    input.clear();
    input.sendKeys("1");
    sleep(2000);
    assert(d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));
    input.sendKeys("5");
    sleep(2000);
    assert(!d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));
    input.sendKeys("8");
    sleep(2000);
    assert(!d.getPageSource().contains("must be greater than 10"));
    assert(!d.getPageSource().contains("must be greater than 20"));

    input.clear();
    input.sendKeys("1");
    var button := d.findElement(SelectBy.className("button"));
    button.click();
    assert(d.getPageSource().contains("must be greater than 10"));
    assert(d.getPageSource().contains("must be greater than 20"));

    assert(d.getPageSource().contains("400px;"));
  }

