application test

  page root(){
    output(q.name)
  }
  
  var q := Thing{ name := "find-this-value" }
  
  entity Thing {
    name :: String
    othersssss -> Set<Thing>
  }
  
  test {
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("find-this-value"));
  }