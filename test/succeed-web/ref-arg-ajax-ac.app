application test

  principal is TextEntity with credentials name

access control rules

  rule page root(){true}

  rule ajaxtemplate showEditableText(e: Ref<Text>, editableText: Placeholder){ principal == e.getEntity() as TextEntity }
  rule ajaxtemplate editEditableText(f: Ref<Text>, editableText: Placeholder){ principal == f.getEntity() as TextEntity }

section pages

  entity TextEntity{
    name :: String
    text::Text 
    t2::Text
  }

  var globaltext := TextEntity{ text := "1" }
  var globaltext2 := TextEntity{ text := "secondtext" }

  define page root(){
    var t := globaltext
    init{ securityContext.principal := t; } //fake login
    
    editableText(t.text)
    <br />
    "should not be accessible:"
    editableText(globaltext2.text)
    
  }
  
  define editableText(text : Ref<Text>) {
    init{ log(""+text.getEntity()); }
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
    assert(!d.getPageSource().contains("secondtext"), "second template should not be shown");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected <a> elements did not match");
    elist[0].click();  

    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("textarea"));
    assert(elist1.length == 1, "expected <textarea> elements did not match");
    elist1[0].sendKeys("2345");
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("12345"), "reference arguments not working as expected");
  }
  
