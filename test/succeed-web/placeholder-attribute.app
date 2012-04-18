application test

  entity Bla {
    val :: String
  }
  
  var b1 := Bla { val := "oldvalue" }

  define page root(){
    form{
      input(b1.val)[placeholder="enter value here!"]
      <input type="text" placeholder="enter value here!"/>
      submit action{} {"save"}
    }
  }
  
  test {
    var d : WebDriver := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().split("placeholder=\"enter value here!\"").length==3);
  }
  

  