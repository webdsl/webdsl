//the new entity should be flushed, so the query has a result

application customer
  
  entity Test  {
    s::String
  }
  
  define page root(){
    placeholder body {  }
    submit action{ replace(body,displayNote()); } { "show" } 
  }
  
  define ajax displayNote(){
    var bla := Test{ s := "123" }
    
    for(t:Test){
      "Test entity exists in database" output(t.s)
    }
    
    form{
      input(bla.s)
      submit action{ bla.save(); replace(body,displayNote()); } { "save" } 
    }
  }
    
  function show(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected <input> elements did not match");
    elist[0].click();
  }
  function send(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected <input> elements did not match");
    elist[1].sendKeys("4"); 
    elist[2].click();
  }
  function check(d:WebDriver){
    assert(d.getPageSource().contains("Test entity exists in database"));
  }
    
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    show(d);
    send(d);
    check(d);
  }
    

  