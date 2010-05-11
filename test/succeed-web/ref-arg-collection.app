application test

  entity Str{
    name::String 
    list->List<Str>
  }
  
  var globalstr1 := Str{ name := "1" }
  var globalstr2 := Str{ name := "2" }

  define page root(){

    var a : List<Str> := List<Str>()
    form{
      bla(a)
      submit action{ var n : Str := Str{ list := a }; n.save();} { "save" }
    }
    for(str:Str){
      output(str) ": " output(str.list)
    } separated-by{ <br /> }
    
  }
  
  define bla(a:Ref<List<Str>>){ 
    input(a)
  }

  define page root2(){

    var a : List<Str> := List<Str>()
    form{
      test(a)
      submit action{ var n : Str := Str{ list := a }; n.save();} { "save" }
    }
    for(str:Str){
      output(str) ": " output(str.list)
    } separated-by{ <br /> }
    
  }
  define test(t:Ref<List<Str>>){ 
    bla(t)
  }
  
  test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    checkpage(d,2);    

    d.get(navigate(root2()));
    checkpage(d,2);    
     
    d.close();
  }
  
  function checkpage(d:WebDriver, clickinput:Int){
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("option"));
    elist[0].setSelected();  
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    elist[clickinput].click();  
    //log(d.getPageSource());
    //log(d.getPageSource());
    assert(d.getPageSource().contains("<li>2</li>"), "reference arguments not working as expected");
  }
  