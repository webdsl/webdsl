application test

page root(){
  navigate action("input" as WikiText){"go to test"}
}

page action(text : WikiText){
  var input := text
  par{ " Linefeed and/or cariage return were not properly encoded in action parameters and caused action lookup failure after saving" }
  if(text.contains("step 2")){
    "step 2 passed"
  }
  
  form{
    input(input)[class="test-input"]{ " Enter text with newlines (and other special chars)" }
    br
    submitlink action{
      return action(input);
    }{ "Save" }
  }
}

template sometemplate(){
  init{
    log("sometemplate hit");
  }
}

  test {
    var d : WebDriver := getFirefoxDriver();
    
    //submit form with newline in text
    d.get(navigate(action("" as WikiText)));    
    var i1 : WebElement := d.findElement(SelectBy.className("test-input"));
    i1.sendKeys("text with \n\n newlines");
    d.getSubmit().click();
    
    i1 := d.findElement(SelectBy.className("test-input"));
    i1.sendKeys("step 2");
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("step 2 passed"));
  }