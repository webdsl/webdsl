application test

  entity Str{
    s::String
    i::Int
    f::Float
  }
  
  define page root(){
    var str := Str{  }
    form{
      bla(str.s)
      bla(str.i)
      localtest(str.f)
      submit action{ str.save(); } { "save" }
    }
    for(str:Str){
      output(str.s)
      output(str.i)
      output(str.f)
    } separated-by{ <br /> }
    define localtest(a: Ref<Float>){
      input(a)
    }
  }
  define localtest(a: Ref<Float>){}
  define bla(a: Ref<String>){ 
    input(a)
  }
  define bla(a: Ref<Int>){ 
    passOn(a)
  }
  define passOn(a: Ref<Int>){ 
    input(a)
  }
  
  test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected <input> elements did not match");
    for(i:Int from 1 to 4){
      elist[i].sendKeys("123");
    }
    elist[4].click();  
    //log(d.getPageSource());
    assert(d.getPageSource().contains("1231230.0123"), "reference arguments not working as expected");
    
    d.close();
  }
  
