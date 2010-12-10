application test

  entity Bla {
    s::String
  }
  var bla := Bla{}
  define page root(){
    var u2 := false
    var s1 := "testtest"
    var b := ""
    
    for(i:Int from 0 to 10){
      testtemplate{ 
        output(u2)
        output(s1)
        output(i) 
      }
    }
    
    form{
      testtemplate{
        input(b)[class="inputb"]
      }
      submit save()[class="saveb"]{"save"}
    }
    action save(){
      bla.s := b;
    }
    
    output(bla.s)
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
    
    var input := d.findElements(SelectBy.className("inputb"))[0];
    input.sendKeys("1234567");
    var button := d.findElements(SelectBy.className("saveb"))[0];
    button.click();
    assert(d.getPageSource().contains("1234567"));
    
    d.close();
    
  }
  

  