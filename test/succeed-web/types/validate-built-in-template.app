// definition for the validate template 

application test
  
  page root(){
    var i := 0
    form{
      input(i)
      validate(i>2,"i must be greater than 2")
      submit action{} [class="savebtn"] {"save"}
    }
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    d.findElement(SelectBy.className("savebtn")).click();
    assert(d.getPageSource().contains("i must be greater than 2"));
  }