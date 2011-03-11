application exampleapp

  entity Ent {
    name :: String
    set -> Set<Ent>
    //list -> List<Ent>
    validate(!(e1 in set), "cannot select e1 in set")
    //validate(!(this in list), "cannot select self in list")
  }


var e1 := Ent{ name := "e1" }
var e2 := Ent{ name := "e2" }
var e3 := Ent{ name := "e3" }
var e4 := Ent{ name := "e4" }
var e5 := Ent{ name := "e5" }

init{
  e1.set := {e2,e3};
  e4.set := {e2,e3};
}

define page root(){
    test(e1)
    
    navigate nolabel(){ "no label"}
}

define test(e:Ent){ 
  " defined output"  
  output(e.set)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      select(e.set,from Ent)[class = "input-elem"]
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
  output(e.set)
  form{
    "defined input"
    select(e.set, from Ent)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
}

test inttemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  
  var input        := d.findElements(SelectBy.className(         "input-elem"))[0];
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
  
  d.close();
}
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  
  var sinput := Select(input);
  
  assert(sinput.isMultiple());
  
  assert(sinput.getAllSelectedOptions().length == 2);
  assert(sinput.getAllSelectedOptions()[0].getText() == e3.name);
  assert(sinput.getAllSelectedOptions()[1].getText() == e2.name);
  
  for(e:Ent in [e1,e2,e3,e4,e5]){
    log("test " +e.name+ ": "+e.id);
  }
  
  sinput.deselectAll();
  d.findElements(SelectBy.className("button-elem"))[0].click();  
  assert(Select(d.findElements(SelectBy.className("input-elem"))[0]).getAllSelectedOptions().length == 0);
  
  Select(d.findElements(SelectBy.className("input-elem"))[0]).selectByIndex(4);
  d.findElements(SelectBy.className("button-elem"))[0].click();  
  
  assert(d.getPageSource().contains("cannot select e1 in set"));
}