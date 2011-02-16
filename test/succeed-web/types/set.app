application exampleapp

  entity Ent {
    name :: String
    set -> Set<Ent>
    //list -> List<Ent>
    validate(!(e1 in set), "cannot select e1 in set")
    //validate(!(this in list), "cannot select self in list")
  }

  define ignore-access-control outputSet1(set : Set<Entity>){
    <ul>
    for(e:Entity in set){
      <li>
        output(e.name)
      </li>
    }
    </ul>
  }
  
  define inputSet1(set:Ref<Set<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputSetInternal(set,from,tname)[all attributes]
      }
    }
    else{
      inputSetInternal(set,from,tname)[all attributes]
    }
    validate{
      errors := set.getValidationErrors();
      errors := handleValidationErrors(errors);
    }
  }

define ignore-access-control inputSetInternal(set : Ref<Set<Entity>>, from : List<Entity>, tname:String){
  var rnamehidden := tname + "_isinput"
  var reqhidden := getRequestParameter(rnamehidden)
  var req : List<String> := getRequestParameterList(tname)
     
  <input type="hidden" name=tname+"_isinput" />
  <select 
    multiple="multiple"
    if(getPage().inLabelContext()) { 
      id=getPage().getLabelString() 
    } 
    name=tname 
    class="select "+attribute("class") 
    all attributes except "class"
  >
    for(e:Entity in from){
      <option 
        value=e.id
        if(reqhidden!=null && req!=null && e.id.toString() in req || reqhidden==null && set != null && e in set){ 
          selected="selected"
        }
      >
        output(e.name)
      </option>  
    }
  </select>

  databind{
    if(reqhidden != null){
      if(req == null || req.length == 0){
        set.clear();
      }
      else{
        var setlist : List<Entity> := set.list();
        var listofcurrentids : List<String> := [ e.id.toString() | e:Entity in setlist ];
        for(s:String in listofcurrentids){
          if(!(s in req) ){
            set.remove([ e | e:Entity in setlist where e.id.toString()==s ][0]);
          }
        }
        for(s:String in req){
          if(!(s in listofcurrentids)){
            set.add([ e | e:Entity in from where e.id.toString()==s ][0]); // check with 'from' list to make sure that it was an option, to protect against tampering
          }
        }
      }
    }
  }
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
  outputSet1(e.set)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputSet1(e.set,from Ent)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.set)
  form{
  "built-in input"
    label(" CLICK ")[class = "built-in-label-elem"]{
      input(e.set)[class = "built-in-input-elem"]
    }
    submit action{}[class = "built-in-button-elem"]{"save"}
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
  outputSet1(e.set)
  form{
    "defined input"
    inputSet1(e.set, from Ent)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.set)
  form{
    "built-in input"
    input(e.set)[class = "built-in-input-elem"]
    submit action{}[class = "built-in-button-elem"]{"save"}
  }
}

test inttemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  
  var input        := d.findElements(SelectBy.className(         "input-elem"))[0];
  var builtininput := d.findElements(SelectBy.className("built-in-input-elem"))[0];
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  var builtinlabel := d.findElements(SelectBy.className("built-in-label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  assert(builtininput.getAttribute("id")==builtinlabel.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
  
  d.close();
}
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  var builtininput := d.findElements(SelectBy.className("built-in-input-elem"))[0];
  
  var sinput := Select(input);
  var sbuiltininput := Select(builtininput);
  
  assert(sinput.isMultiple());
  assert(sbuiltininput.isMultiple());
  
  assert(sinput.getAllSelectedOptions().length == 2);
  assert(sbuiltininput.getAllSelectedOptions().length == 2);
  assert(sinput.getAllSelectedOptions()[0].getText() == e3.name);
  assert(sbuiltininput.getAllSelectedOptions()[0].getText() == e3.name);
  assert(sinput.getAllSelectedOptions()[1].getText() == e2.name);
  assert(sbuiltininput.getAllSelectedOptions()[1].getText() == e2.name);
  
  for(e:Ent in [e1,e2,e3,e4,e5]){
    log("test " +e.name+ ": "+e.id);
  }
  
  sinput.deselectAll();
  d.findElements(SelectBy.className("button-elem"))[0].click();  
  assert(Select(d.findElements(SelectBy.className("input-elem"))[0]).getAllSelectedOptions().length == 0);
  assert(Select(d.findElements(SelectBy.className("built-in-input-elem"))[0]).getAllSelectedOptions().length == 0);
  
  Select(d.findElements(SelectBy.className("input-elem"))[0]).selectByIndex(4);
  d.findElements(SelectBy.className("button-elem"))[0].click();  
  
  assert(d.getPageSource().contains("cannot select e1 in set"));
}