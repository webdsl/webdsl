application exampleapp
  
  entity Bla {
    name :: String
    s::WikiText
    t::Text
    u::URL
    e::Secret
    validate(name.length() > 2, "length must be greater than 2")
    validate(s.length() > 2, "length must be greater than 2")
    validate(t.length() > 2, "length must be greater than 2")
    validate(u.length() > 2, "length must be greater than 2")
    validate(e.length() > 2, "length must be greater than 2")
  }
  
  var e1 := Bla{name := "123" s := "213" t := "213" u := "213" e := "213" }
  
  define page root(){
    form{
      inputajax(e1.name)[style="width:400px;", class="in1"]{
        validate(e1.name.length() > 3, "length must be greater than 3")
      }
      inputajax(e1.s)[style="width:400px;", class="in2"]{
         validate(e1.s.length() > 3, "length must be greater than 3")
      }
      inputajax(e1.t)[style="width:400px;", class="in3"]{
         validate(e1.t.length() > 3, "length must be greater than 3")
      }
      inputajax(e1.u)[style="width:400px;", class="in4"]{
         validate(e1.u.length() > 3, "length must be greater than 3")
      }
      inputajax(e1.e)[style="width:400px;", class="in5"]{
         validate(e1.e.length() > 3, "length must be greater than 3")
      }
      submit action{} {"save"}
    }
  }
  
  test stringtemplate {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var input :WebElement;
    for(i:Int from 1 to 6){
      input := d.findElement(SelectBy.className("in"+i));
      input.clear();
      sleep(2000);
      input.sendKeys("1");
      sleep(2000);
      assert(d.getPageSource().split("length must be greater than 2").length==2);
      assert(d.getPageSource().split("length must be greater than 3").length==2);
      for(s:String in "234".split()){
        input.sendKeys(s);
        sleep(1000);
      }
      sleep(2000);
    }

    for(i:Int from 1 to 6){
      input := d.findElement(SelectBy.className("in"+i));
      input.clear();
      sleep(2000);
      input.sendKeys("1");
      sleep(2000);
    }
    var button := d.findElement(SelectBy.className("button"));
    button.click();
    assert(d.getPageSource().split("length must be greater than 2").length==6);
    assert(d.getPageSource().split("length must be greater than 3").length==6);
    assert(d.getPageSource().split("400px;").length==6);
  }

