application test
  
  var t_1 := TestInput{ name := "1" }
  var t_2 := TestInput{name := "2"}

  entity SomeEntity{
    name :: String
  }
  
  var s_1 := SomeEntity { name := "s1" }
  var s_2 := SomeEntity { name := "s2" }
  var s_3 := SomeEntity { name := "s3" }
  var s_4 := SomeEntity { name := "s4" }
  
  entity TestInput{
    name::String
    b::Bool
    i::Int
    f::Float
    l::Long
    s::String
    s1::Secret
    s2::URL
    s3::Text
    s4::WikiText
    s5::Text // to hold inputsdf result
    list -> List<SomeEntity>
    set -> Set<SomeEntity>
    ent -> SomeEntity
  }

  define page root(){
    inputswithajax(t_1)
    //inputswithajax(t_2)
  }
  
  define inputswithajax(t:TestInput){
    form{
      inputajax(t.b)[class="b"+t.name]
      inputajax(t.i)[class="i"+t.name]
      inputajax(t.f)[class="f"+t.name]
      inputajax(t.l)[class="l"+t.name]
      inputajax(t.s)[class="s"+t.name]
      inputajax(t.s1)[class="s1"+t.name]
      inputajax(t.s2)[class="s2"+t.name]
      inputajax(t.s3)[class="s3"+t.name]
      inputajax(t.s4)[class="s4"+t.name]
      inputSDFajax(t.s5,"sdfinputexamplelang")[class="s5"+t.name]
      inputajax(t.list)[class="list"+t.name]
      inputajax(t.set)[class="set"+t.name]
      inputajax(t.ent)[class="ent"+t.name]
      submit action{}[class="button"+t.name] {"save"}
    }
    output(t.b)
    output(t.i)
    output(t.f)
    output(t.l)
    output(t.s)
    output(t.s1)
    output(t.s2)
    output(t.s3)
    output(t.s4)
    output(t.s5)
    output(t.list)
    output(t.set)
    output(t.ent)  	
  }

  native class Thread {
    static sleep(Int)
  }

  test inputajaxtests{
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    d.findElement(SelectBy.className("b1")).click();
    Thread.sleep(1000);
    for(s:String in "234".split()){
      d.findElement(SelectBy.className("i1")).sendKeys(s);
      Thread.sleep(1000);
    }
    for(s:String in "646".split()){
      d.findElement(SelectBy.className("f1")).sendKeys(s);
      Thread.sleep(1000);
    }
    for(s:String in "345".split()){
      d.findElement(SelectBy.className("l1")).sendKeys(s);
      Thread.sleep(1000);
    }
    for(s:String in "abc".split()){
      d.findElement(SelectBy.className("s51")).sendKeys(s);
      Thread.sleep(1000);
    }
    d.findElement(SelectBy.className("button1")).click();
    Thread.sleep(1000);
    //log(d.getPageSource());
    assert(d.getPageSource().contains("2340.0646345"));
    d.close();
  }
