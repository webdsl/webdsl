application exampleapp

  entity Ent {
    name :: String
    ent -> Ent
    validate(e1 != ent, "cannot select e1")
  }

/*
  define ignore-access-control outputEntity1(ent : Entity){
    navigate 
    for(e:Entity in set){
      <li>
        output(e.name)
      </li>
    }
    </ul>
  }
  */
  define inputEntity1(ent : Ref<Entity>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputEntityInternal(ent,from,tname)[all attributes, not null]
      }
    }
    else{
      inputEntityInternal(ent,from,tname)[all attributes, not null]
    }
    validate{
      errors := ent.getValidationErrors();
      errors := handleValidationErrors(errors);
    }
  }

define ignore-access-control inputEntityInternal(ent : Ref<Entity>, from : List<Entity>, tname:String){
  var rnamehidden := tname + "_isinput"
  var reqhidden := getRequestParameter(rnamehidden)
  var req : String := getRequestParameter(tname)
  var notnull := hasNotNullAttribute() || ent.getReflectionProperty().hasNotNullAnnotation()
  <input type="hidden" name=tname+"_isinput" />
  <select 
    if(getPage().inLabelContext()) { 
      id=getPage().getLabelString() 
    } 
    name=tname 
    class="select "+attribute("class") 
    all attributes except "class"
  >
    if(!notnull){
      <option value="none"
        if(reqhidden!=null && req==null || reqhidden==null && ent == null){ 
          selected="selected"
        }
      ></option>
    }
    for(e:Entity in from){
      <option 
        value=e.id
        if(reqhidden!=null && req!=null && e.id.toString() == req || reqhidden==null && e == ent){ 
          selected="selected"
        }
      >
        output(e.name)
      </option>  
    }
  </select>

  databind{
    if(reqhidden != null){
      if(!notnull && req == "none"){
        ent := null;
      }
      else{
        var fromids := [ e | e:Entity in from where e.id.toString()==req ];
        if(fromids.length > 0){
          ent := fromids[0]; // check with 'from' list to make sure that it was an option, to protect against tampering
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
  //outputEntity1(e.ent)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputEntity1(e.ent,from Ent)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.ent)
  form{
  "built-in input"
    label(" CLICK ")[class = "built-in-label-elem"]{
      input(e.ent)[class = "built-in-input-elem"]
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
  //outputSet1(e.set)
  form{
    "defined input"
    inputEntity1(e.ent, from Ent)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.ent)
  form{
    "built-in input"
    input(e.ent)[class = "built-in-input-elem"]
    submit action{}[class = "built-in-button-elem"]{"save"}
  }
}

test entityreftemplates {
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
  
  //check not null anno from entity
  d.get(navigate(testnotnull()));
  var l1 := Select(d.findElements(SelectBy.className("elem-test-1"))[0]).getOptions().length;
  assert(l1 == 5);
  var l2 := Select(d.findElements(SelectBy.className("elem-test-2"))[0]).getOptions().length;
  assert(l2==5);
  var l3 := Select(d.findElements(SelectBy.className("elem-test-3"))[0]).getOptions().length;
  assert(l3==5);
  
  d.close();
}

  entity Ent2 {
    ent -> Ent (not null)
  }
  
  var ent2 := Ent2{ }
  
  define page testnotnull(){
    form{
      inputEntity1(e1.ent,from Ent)[class = "elem-test-1",not null]
      inputEntity1(ent2.ent,from Ent)[class = "elem-test-2"]
      input(ent2.ent)[class = "elem-test-3"]
    }	
  }
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  var builtininput := d.findElements(SelectBy.className("built-in-input-elem"))[0];
  
  var sinput := Select(input);
  var sbuiltininput := Select(builtininput);
  
  assert(!sinput.isMultiple());
  assert(!sbuiltininput.isMultiple());
  
  assert(sinput.getAllSelectedOptions().length == 1);
  assert(sbuiltininput.getAllSelectedOptions().length == 1);
  assert(sinput.getAllSelectedOptions()[0].getText() == e2.name);
  assert(sbuiltininput.getAllSelectedOptions()[0].getText() == e2.name);
  
  for(e:Ent in [e1,e2,e3,e4,e5]){
    log("test " +e.name+ ": "+e.id);
  }
  
  Select(d.findElements(SelectBy.className("input-elem"))[0]).selectByIndex(5);
  d.findElements(SelectBy.className("button-elem"))[0].click();  
  assert(d.getPageSource().contains("cannot select e1"));

  Select(d.findElements(SelectBy.className("built-in-input-elem"))[0]).selectByIndex(5);
  d.findElements(SelectBy.className("built-in-button-elem"))[0].click();  
  assert(d.getPageSource().contains("cannot select e1"));
  
}

