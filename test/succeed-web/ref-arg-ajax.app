application test

  entity TextEntity{
    text::Text 
  }
  
  var globaltext := TextEntity{ text := "1" }

  define page root(){
    var tmp := globaltext
    submit action{replace(b,bla(tmp.text));} {"replace" }
    placeholder b { }
    output(globaltext.text)
  }
  
  define ajax bla(t:Ref<Text>){
    form{
      input(t)
      submit action{} {"save"}
    }
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    d.getSubmit().click();
     
    var tlist : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(tlist.length == 1, "expected <textarea> elements did not match");
     
    tlist[0].sendKeys("234567890");  
    d.getSubmits()[1].click();
        
    assert(d.getPageSource().contains("1234567890"), "reference arguments not working as expected");
  }
  
