application test

  define a(){
    "a"
    elements()
  }
  
  define b(){
    "b"
    elements()
  }
  
  define c(){
    "c"
    elements()
  }
  
  entity Ent {
    i :: Int
  }

  define page root(){
    var e := Ent{ i := 2 }
    form{
      a{
        output(e.i)
        b{
          c{
            "elementsshown" input(e.i)
          }
        }
        submit action{ e.save(); } { "save" }
      }
    }
    for(en : Ent){
      output(en.i)
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("elementsshown"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[1].sendKeys("345");
    elist[2].click();
    
    assert(d.getPageSource().contains("2345"),"Ent not saved");
  }
  

  