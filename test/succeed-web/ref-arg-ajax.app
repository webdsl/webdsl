application test

  entity TextEntity{
    text::Text 
  }
  
  var globaltext := TextEntity{ text := "1" }

  define page root(){
    var tmp := globaltext
    submit action{replace(b,bla(tmp.text));} {"replace" }
    
    placeholder b {
        
    }
    
    output(globaltext.text)
  }
  
  define ajax bla(t:Ref<Text>){
    form{
      input(t)
      submit action{} {"save"}
    }
  }
  
  native class Thread { static sleep(Int) }

  test one {
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected <input> elements did not match");
    
    elist[0].click();
    Thread.sleep(2000);
    
    var tlist : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(tlist.length == 1, "expected <textarea> elements did not match");
     
    tlist[0].sendKeys("234567890");  
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected <input> elements did not match");
    elist[3].click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("1234567890"), "reference arguments not working as expected");
    
    d.close(); 
  }
  
