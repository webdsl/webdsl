application email

  entity EmailHolder {
    e1 :: Email (not empty)
    e2 :: Email
  }

  var eh := EmailHolder{ e1 := "" e2 := "" }

  define page root() {
    form {
      label("e1 (not empty): "){
        input(eh.e1)
      }
      label("e2: "){
        input(eh.e2)
      }
      submit("Save", action{})
    }
  }

  test emailaddressrequired {
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    assert(!/404/.find(d.getPageSource()), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    
    var size := elist.length;
    
    assert(size==4,"expected 4 input elements");
    
    elist[3].click();
  
    var list := /required/.split(d.getPageSource());
    
    assert(list.length == 2, "expected one occurence of \"required\"");
    d.close();
  }