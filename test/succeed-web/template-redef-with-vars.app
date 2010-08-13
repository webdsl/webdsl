
application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var st := "1"
    var ins := 3
    form{
      b(12345)  	
      submit action{ TestEntity{ name := st+ins }.save(); } {"save"}
    } 
    for(te:TestEntity){
      output(te.name)
    }

    define b(i:Int) = a(*,st,ins)
  }

  define a(i:Int, s:Ref<String>, ins: Ref<Int>){
    output(i)
    input(s)
    input(ins)
  }
  
  define b(i:Int){
    "error"
  }

  test var {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("12345"), "regular arg not passed");
  
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected 5 <input> elements did not match");
    elist[2].sendKeys("dfsdfg");
    elist[3].sendKeys("234567");
    elist[4].click();
    
    assert(d.getPageSource().contains("dfsdfg3234567"), "resulting name incorrect");

    d.close();
  }
  
