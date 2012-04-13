//due to a bug in the handling of ajax actions, the entered value ("12") was shown after executing the action instead of the expected "1",
// reason was that old request parameters were still visible when ajax render occurred, which caused the input to show that value instead of the real value.

application customer
  
  session bla {
    s::String
  }
  
  define page root(){
    placeholder body{ displayNote() }
  }
  
  define ajax displayNote(){
    init{
        bla.s := "1";	
    }
    
    form{
      input(bla.s)
      submit action{ replace(body,displayNote()); } { "save" } 
    }
    output(bla.s)
    "important"
  }
      
  function send(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");

    elist[1].sendKeys("2"); 
    elist[2].click();
  }
  function check(d:WebDriver){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    assert(elist[1].getValue() == "1");
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    send(d);
    send(d);
    send(d);
    check(d);
  }
    
  
    