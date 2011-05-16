application exampleapp

  entity Ent {
    ents -> Set<Ent>
    validate(!(e1 in ents), "cannot select e1")
  }
  
  var e1 := Ent{  }
  var e2 := Ent{  }
  
  define page root(){
    form{
      inputajax(e1.ents)[style="color:blue;"]{
         validate(!(e2 in e1.ents), "cannot select e2")
      }
      submit action{}[class="button"] {"save"}
    }
  }

  test inputajaxtests{
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    var options := d.findElements(SelectBy.cssSelector("input[type='checkbox']"));
    options[0].click();
    Thread.sleep(2000);
    options[1].click();
    Thread.sleep(2000);
    assert(d.getPageSource().contains("cannot select e1"));
    assert(d.getPageSource().contains("cannot select e2"));
    var button := d.findElement(SelectBy.className("button"));
    button.click();
    assert(d.getPageSource().contains("cannot select e1"));
    assert(d.getPageSource().contains("cannot select e2"));
    
    options := d.findElements(SelectBy.cssSelector("input[type='checkbox']"));
    options[0].click();
    Thread.sleep(2000);
    options[1].click();
    Thread.sleep(2000);
    assert(!d.getPageSource().contains("cannot select e1"));
    assert(!d.getPageSource().contains("cannot select e2"));
    
    d.close();
  }