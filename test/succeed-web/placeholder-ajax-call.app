application customer
  
  entity Bla{
    s::String
    validate(s.length()>2,"too short")
  }
  
  define page root(){
    placeholder body displayNote(body)
  }
  define ajax displayNote(body: Placeholder){
    form{
      input(bla.s)
      submit action{ replace(body,displayNote(body)); } { "save" } 
    }
  }
  
  define page root1(){
    placeholder "body" displayNote1()
  }
  define ajax displayNote1(){
    form{
      input(bla1.s)
      submit action{ replace("body",displayNote1()); } { "save" } 
    }
  }
  
  var bla := Bla{}
  var bla1 := Bla{}
  
  function send(d:WebDriver, elems: Int){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == elems, "expected <input> elements did not match");
    elist[(elems-1)].sendKeys("2"); 
    d.getSubmit().click();
  }
  
  function check(d:WebDriver, elems: Int){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == elems, "expected <input> elements did not match");
    assert(elist[(elems-1)].getValue() == "2");
    assert(d.getPageSource().contains("too short"));
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root()));
    send(d,3);
    check(d,3);
    
    d.get(navigate(root1()));
    send(d,2);
    check(d,2);
  }
  