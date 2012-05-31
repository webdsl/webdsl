application test

  entity Str{
    t :: Text 
  }
  
  var globalstr := Str{ t := "1" }

  define page root(){
    form{
      testinput(globalstr.t)
      submitlink action{} {"save"}
    }
  }
  
  define testinput(s:Ref<Text>){
    input(s)
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    elist[0].sendKeys("23456");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    elist[0].click();  
    assert(d.getPageSource().contains("123456"), "reference arguments not working as expected");
  }
  
