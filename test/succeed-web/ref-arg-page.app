application test

  entity TextEntity{
    text::Text (name)
  }
  entity TextEntity2{
    text::Text (name)
  }
  init{
    var t := TextEntity{ text := "1" };
    t.save();
    var t := TextEntity2{ text := "2" };
    t.save();
  }
  define page root(){
    var t :=(from TextEntity)[0];
    var t1 :=(from TextEntity2)[0];
    navigate edit(t.text) { "go" }
    navigate edit((from TextEntity2)[0].text) { "go" }
  }

  define page edit(text : Ref<Text>) {
    form{
      input(text)
      submit action{} {"save"}
    }
    output((from TextEntity)[0].text)
    output((from TextEntity2)[0].text)
  }

  define page bla(s:String){}

  test one {
    
    var d : WebDriver := FirefoxDriver();

    testpage(d,0);
    assert(d.getPageSource().contains("1abcde2"), "reference arguments not working as expected");
    
    testpage(d,1);
    assert(d.getPageSource().contains("1abcde2abcde"), "reference arguments not working as expected");
    
    d.close(); 
    
  }
  
  function testpage(d:WebDriver,i:Int){
     d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 2, "expected <a> elements did not match");
    elist[i].click();
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(elist.length == 1, "expected <textarea> elements did not match");
    elist[0].sendKeys("abcde");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[2].click();
  }
  
