//the new entity should be flushed, so the query has a result

application customer
  
  entity Test  {
    s::String
  }
  
  define page root(){
    placeholder body {  }
    submit action{ replace(body,displayNote(body)); } { "show" } 
  }
  
  define ajax displayNote(p: Placeholder){
    var bla := Test{ s := "123" }
    
    for(t:Test){
      "Test entity exists in database" output(t.s)
    }
    
    form{
      input(bla.s)
      submit action{ bla.save(); replace(p,displayNote(p)); } { "save" } 
    }
  }
    
  function show(d:WebDriver){
    d.getSubmit().click();
  }
  function send(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[2].sendKeys("4"); 
    d.getSubmit().click();
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
    

  