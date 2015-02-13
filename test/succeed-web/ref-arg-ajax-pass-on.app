application test

  entity TextEntity{
    text::Text 
  }
  
  var globaltext := TextEntity{ text := "1" }

  define page root(){
    var t := globaltext
    editableText(t.text)
  }
  
  define editableText(text : Ref<Text>) {
    placeholder editableText {
      showEditableText(text, editableText)
    }
  }

  define ajax showEditableText(text : Ref<Text>, editableText: Placeholder) {
    output(text)
    submitlink action{ replace(editableText, editEditableText(text, editableText)); } { "[Edit]" }
  }

  define ajax editEditableText(text : Ref<Text>, editableText: Placeholder) {
    form{
      input(text)
      submit action{ replace(editableText, showEditableText(text, editableText)); } { "Save" }
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected <a> elements did not match");
    elist[0].click();  
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(elist1.length == 1, "expected <textarea> elements did not match");
    elist1[0].sendKeys("2345");
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("12345"), "reference arguments not working as expected");
  }
  
