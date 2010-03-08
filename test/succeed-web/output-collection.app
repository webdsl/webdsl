application test

  entity ColTest { // no viewpage
    name :: String
    list -> List<ColTest>
    set -> Set<ColTest>
    
    list2 -> List<ColTest2>
    set2 -> Set<ColTest2>
    
  }
  
  entity ColTest2{name :: String} // has viewpage
  define page colTest2(ct:ColTest2){}
  
  var ct1 := ColTest{ name := "1" list := [ct2,ct3] set := {ct2,ct3} list2:=[ct21] set2:={ct22}} 
  var ct2 := ColTest{ name := "2"  } 
  var ct3 := ColTest{ name := "3" list := [ct3] set := {ct3} } 
  var ct4 := ColTest{ name := "4" list := [ct3,ct3,ct3] set := {ct2,ct3,ct4,ct5} } 
  var ct5 := ColTest{ name := "5" list := [ct5] list2:=[ct21,ct22,ct22] set2:={ct21,ct22}} 
  
  var ct21 := ColTest2{ name := "6" }
  var ct22 := ColTest2{ name := "7" }

  define page root(){
    for(ct : ColTest){
      par{
        output(ct)
        output(ct.name)
        output(ct.list)
        output(ct.set)
        output(ct.list2)
        output(ct.set2)
      }
    }
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("li"));
    assert(elist.length == 21, "expected <li> elements did not match");

    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 7, "expected <a> elements did not match");
    
    d.close();
  }
  