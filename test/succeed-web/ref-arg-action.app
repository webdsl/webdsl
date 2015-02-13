application test
//http://yellowgrass.org/issue/WebDSL/754
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
    navigate show(t.text) { "go" }
  }

  define page show(text : Ref<Text>) {
   var type:= text.getEntity();
   
   if (type is a TextEntity){ submitlink action{ 
      return root();
    } {"PASS"} }
   else { output("FAIL")}
   
  }

  test {
    var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected <a> elements did not match");
    elist[0].click();
    assert(d.getPageSource().contains("PASS"), "reference arguments not working as expected");
  }
  
