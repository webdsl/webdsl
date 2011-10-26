//regression test for incorrect translation of validation phase for form element

application exampleapp
  
  entity Bla {
    bla :: Bool
    forceTrue :: Bool
    
    validate(!forceTrue || bla, "force true was enabled, but value was false")
  }
  
  var bg := Bla{ bla := true forceTrue:=true}
  
  define page root(){
    form{
    }	
    form{
      input(bg.bla)
      <hr />
      submit action{} {"save"}
    }
  }

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected 5 <input> elements");
    
    elist[3].click();
    elist[4].click();
    
    var pagesource := d.getPageSource();
    var list := pagesource.split("<hr");
    
    assert(list.length == 2, "expected one occurences of \"<hr\"");
 
    assert(list[0].contains("force true was enabled, but value was false"), "error message not in correct location or not rendered at all");
  }



