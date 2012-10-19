application test

  entity Str{
    name::String 
  }
  
  var globalstr := Str{ name := "1" }

  define page root(){
    var a : String := "1"
    var b : String := "2"
    var c : String := "3"
    var d : Int := 1
    var e : Int := 2
    var f : Str := globalstr
    var g : Bool := true
    
    var a1 :="1"
    var a2 :="1"
    var a3 :="1"
    form{
      bla(a,b,c,d,e,f,g)
      localtest(a1,a2,a3)
      submit action{ var n := Str{name:=a+" "+b+" "+c+" "+d+" "+e+" "+f.name+" "+g+" "+a1+" "+a2+" "+a3}; n.save();} { "save" }
    }
    for(str:Str){
      output(str)
    } separated-by{ <br /> }
    
    define localtest(a: Ref<String>, b : String, c: Ref<String>){
      var b1 := b
      input(a)
      input(b1)
      input(c)
    }
  }
  
  define localtest(a: Ref<String>, b : String, c: Ref<String>){}
  
  define bla(a: Ref<String>, b : String, c: Ref<String>, d : Int, e: Ref<Int>, f : Ref<Str>, g: Ref<Bool>){ 
    var b1 := b
    var d1 := d
    passOn(a)
    input(b1)
    input(c)
    input(d1)
    input(e)
    input(f)
    input(g)
  }
  
  define passOn(a: Ref<String>){
    input(a)
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 13, "expected <input> elements did not match");
    for(i:Int from 1 to 6){ //6,7,8 hidden
      elist[i].sendKeys("0");
    }
    for(i:Int from 9 to 12){
      elist[i].sendKeys("0");
    }
    elist[12].click();  

    assert(d.getPageSource().contains("10 2 30 1 20 1 true 10 1 10"), "reference arguments not working as expected");
  }
  
