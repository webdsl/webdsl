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
      showEditableText(text)
    }
  }

  define ajax showEditableText(text : Ref<Text>) {
    output(text)
    submitlink action{ replace(editableText, editEditableText(text)); } { "[Edit]" }
  }

  define ajax editEditableText(text : Ref<Text>) {
    form{
      input(text)
      submit action{ replace(editableText, showEditableText(text)); } { "Save" }
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected <a> elements did not match");
    elist[0].click();  
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(elist.length == 1, "expected <textarea> elements did not match");
    elist[0].sendKeys("2345");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[2].click();

    assert(d.getPageSource().contains("12345"), "reference arguments not working as expected");
  }
  
