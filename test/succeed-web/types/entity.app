application exampleapp

  entity Ent {
    name :: String
    ent -> Ent
    validate(e1 != ent, "cannot select e1")
  }
 
var e1 := Ent{ name := "e1" }
var e2 := Ent{ name := "e2" }
var e3 := Ent{ name := "e3" }
var e4 := Ent{ name := "e4" }
var e5 := Ent{ name := "e5" }

init{
  e1.ent := e2;
  e4.ent := e2;
}

define page root(){
    test(e1)
    
    navigate nolabel(){ "no label"}
    navigate testnotnull(){"not null"}
}

define test(e:Ent){ 
  " defined output"  
  output(e.ent)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      input(e.ent)[class = "input-elem"] //defined in built-in.app
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
}


define page nolabel(){
  testnolabel(e4)
}

define testnolabel(e:Ent){ 
  init{
    for(e:Ent in [e1,e2,e3,e4,e5]){
      log("page: "+e.name+ ": "+e.id);
    }
  }
  " defined output"
  output(e.ent)
  form{
    "defined input"
    input(e.ent)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
}

test entityreftemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  
  var input := d.findElements(SelectBy.className("input-elem"))[0];
  var label := d.findElements(SelectBy.className("label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
  
  //check not null anno from entity
  d.get(navigate(testnotnull()));
  var l1 := Select(d.findElement(SelectBy.className("elem-test-1"))).getOptions().length;
  assert(l1 == 5);
  var l2 := Select(d.findElement(SelectBy.className("elem-test-2"))).getOptions().length;
  assert(l2==5);
  var l3 := Select(d.findElement(SelectBy.className("elem-test-3"))).getOptions().length;
  assert(l3==5);
  
  d.close();
}

  entity Ent2 {
    ent -> Ent (not null)
  }
  
  var ent2 := Ent2{ }
  
  define page testnotnull(){
    form{
      input(e1.ent)[class = "elem-test-1",not null]
      input(ent2.ent)[class = "elem-test-2"]
      input(ent2.ent)[class = "elem-test-3"]
    }	
  }
  
function commonTest(d:WebDriver){  
  var input := d.findElement(SelectBy.className("input-elem"));
  
  var sinput := Select(input);
  
  //assert(!sinput.isMultiple()); broken in new webdriver version?
  
  assert(sinput.getAllSelectedOptions().length == 1);
  assert(sinput.getAllSelectedOptions()[0].getText() == e2.name);
  
  for(e:Ent in [e1,e2,e3,e4,e5]){
    log("test " +e.name+ ": "+e.id);
  }
  
  Select(d.findElement(SelectBy.className("input-elem"))).selectByVisibleText("e1");
  d.findElement(SelectBy.className("button-elem")).click();
  assert(d.getPageSource().contains("cannot select e1"));

}

