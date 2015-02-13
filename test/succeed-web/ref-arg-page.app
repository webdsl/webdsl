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
    var t1 := TextEntity2{ text := "2" };
    t1.save();
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

  test {
    var d : WebDriver := getFirefoxDriver();

    testpage(d,0);
    assert(d.getPageSource().contains("1abcde2"), "reference arguments not working as expected");
    
    testpage(d,1);
    assert(d.getPageSource().contains("1abcde2abcde"), "reference arguments not working as expected");
  }
  
  function testpage(d:WebDriver,i:Int){
     d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 2, "expected <a> elements did not match");
    elist[i].click();
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(elist1.length == 1, "expected <textarea> elements did not match");
    elist1[0].sendKeys("abcde");
    
    d.getSubmit().click();
  }
  
