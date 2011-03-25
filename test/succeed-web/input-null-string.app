application formcheckseparate

 
  define page root(){
    var s1 : String := null
    var s2 : Secret := null
    var s3 : Text := null
    var s4 : WikiText := null
    var s5 : Email := null
    var s6 : URL := null
    
    form {
      input(s1)
      input(s2)
      input(s3)
      input(s4)
      input(s5)
      input(s6)
      submit action{} { "save" }
    }
    
  }
  
  define page root2(){
    var s := "null"
    input(s)
  }


  test one {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("\"null\""), "null value should not be shown");
    
    d.get(navigate(root2()));
    assert(d.getPageSource().contains("null"), "null string should be shown");

    d.close();
  }
  