application formcheckseparate

  entity ValidationTest {
    property1 :: Int
    property2 :: Int
    
    validate(property2 < property1, "property2 must be smaller than property1")
  }
  
  define page root() {
    title { "root page" }
   
    for(vt : ValidationTest){
      output(vt.property1)
      output(vt.property2)
    }

    var v := ValidationTest { property1 := 2 property2 := 1 }
    form {
      label("Property 1") { input(v.property1) }
      label("Property 2") { input(v.property2) }
      action("save",save())
    }
    action save(){
      v.save();
      return success();
    }
  }
  
  define page success(){
    title { "successfully performed edit" }
    for(vt : ValidationTest){
      output(vt.property1)
      output(vt.property2)
    }
  }

    
  test inputvalidate {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");

    var elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    
    elist[1].clear();
    elist[1].sendKeys("0");
    elist[3].click();
    
    assert(d.getPageSource().contains("property2 must be smaller than property1"), "didn't find validation message in page output");
   
    d.close();
  }
  