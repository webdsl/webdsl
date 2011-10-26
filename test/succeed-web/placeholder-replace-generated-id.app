application test

  entity Test{name :: String}

  var gt1 := Test{name := "1"}
  var gt2 := Test{name := "2"}
  var gt3 := Test{name := "3"}
  var gt4 := Test{name := "4"}

  define page root() {
    for(t: Test){
      placeholder "ph"+t.id { }
    }
    form{
      submit rep()[ajax] { "replace" }
    }
    action rep(){
      for(t:Test){  		
        replace("ph"+t.id, bla(t));
      }
    }
  }

  define ajax bla(t:Test){
    "ajax replace executed: " output(t.name)
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));

    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected 2 <input> elements did not match");
    
    elist[1].click();
    
    for(i:Int from 1 to 5){
      assert(d.getPageSource().contains("ajax replace executed: "+i));
    }
  }
  
