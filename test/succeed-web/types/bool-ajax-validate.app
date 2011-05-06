application exampleapp

  entity Ent {
    b::Bool
    validate(!b, "b must be false")
  }
  
  var e1 := Ent{}
  
  define page root(){
    form{
      inputajax(e1.b)[style="width:400px;"]{
        validate(!e1.b, "b must still be false")
      }
      submit action{} {"save"}
    }
  }
  
  test booltemplate {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    var input := d.findElement(SelectBy.className("inputBool"));
    input.click();
    Thread.sleep(2000);
    assert(d.getPageSource().contains("b must be false"));
    assert(d.getPageSource().contains("b must still be false"));
    var button := d.findElement(SelectBy.className("button"));
    button.click();
    assert(d.getPageSource().contains("b must be false"));
    assert(d.getPageSource().contains("b must still be false"));
    assert(d.getPageSource().contains("400px"));
    d.close();
  }
