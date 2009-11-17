application test


  define page root(){
    var u2 := false
    var s1 := "testtest"
    for(i:Int from 0 to 10){
      testtemplate{ 
        output(u2)
        output(s1)
        output(i) 
      }
    }
    
  }
  
  define testtemplate(){
    <h1>
      elements
    </h1>
  }

  test one {
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    
    assert(d.getPageSource().contains("testtest"),"template call with elements failed");
    
  }
  

  