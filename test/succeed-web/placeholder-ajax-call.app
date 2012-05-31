application customer
  
  entity Bla{
    s::String
    validate(s.length()>2,"too short")
  }
  
  define page root(){
    placeholder body displayNote()
  }
  define ajax displayNote(){
    form{
      input(bla.s)
      submit action{ replace(body,displayNote()); } { "save" } 
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
  
  function send(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[1].sendKeys("2"); 
    elist[2].click();
  }
  
  function check(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    assert(elist[1].getValue() == "2");
    assert(d.getPageSource().contains("too short"));
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root()));
    send(d);
    check(d);
    
    d.get(navigate(root1()));
    send(d);
    check(d);
  }
  