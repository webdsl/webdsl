application test

  entity Str{
    s::String
    i::Int
    f::Float
    c->Set<Str>
    d->Set<Str>
  }
  
  var globalstr := Str{s := "str1"}
  
  define page root(){
    var str := Str{  }
    form{
      bla(str.s)
      bla(str.i)
      localtest(str.f)
      bla(str.c)
      blapasson(str.d)
      submit action{ str.save(); } { "save" }
    }
    for(str:Str){
      output(str.s)
      output(str.i)
      output(str.f)
      output(str.c.list()[0].s)
      output(str.d.list()[0].s)
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
  define bla(c: Ref<Set<Str>>){ 
    select(c, from Str)
  } 
  define blapasson(c: Ref<Set<Str>>){ 
    bla(c)
  } 
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    for(i:Int from 1 to 4){
      elist[i].sendKeys("123");
    }
    var olist : List<WebElement> := d.findElements(SelectBy.tagName("option"));
    olist[0].setSelected();
    olist[1].setSelected();
    elist[6].click();  

    assert(d.getPageSource().contains("1231230.0123str1str1"), "reference arguments not working as expected");
  }
