application exampleapp

entity Ent {
  i :: Float
  validate(i > 99.0, "must be smaller than 99.0")
}

define ignore-access-control outputInt1(i : Int){
  output(i.toString())
}
define ignore-access-control validate inputInt1(i : Ref<Int>){
  var rname := getUniqueTemplateId()
  var req := getRequestParameter(rname)
  <input 
    if(inLabelContext()) { 
      id=getLabelString() 
    } 
    name=rname 
    if(req != null){ 
      value = req 
    }
    else{
      value = i 
    }
    class="inputInt "+attribute("class") 
    all attributes except "class"
  />

  databind{
    if(req != null){
      i := req.parseInt();
    }
  }
  
  if(req != null){
    if(/-?\d+/.match(req)){
      validate(req.parseInt() != null,"Outside of possible number range")
    }
    else{
      validate(false,"Not a valid number")
    }
  }
}

var e1 := Ent{ i := 5 }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  outputInt1(e.i)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputInt1(e.i)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.i)
  form{
  "built-in input"
    label(" CLICK ")[class = "built-in-label-elem"]{
      input(e.i)[class = "built-in-input-elem"]
    }
    submit action{}[class = "built-in-button-elem"]{"save"}
  }
}

test inttemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  var builtininput := d.findElements(SelectBy.className("built-in-input-elem"))[0];
  assert(       input.getValue()=="5");
  assert(builtininput.getValue()=="5");
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  var builtinlabel := d.findElements(SelectBy.className("built-in-label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  assert(builtininput.getAttribute("id")==builtinlabel.getAttribute("for"));
 
  //add an 8 in the defined input to make 58
  //defined input
  inputDefinedCheck(d,"58","defined output58");
  //built-in input
  inputBuiltinCheck(d,"546","built-in output546");
  
  //trigger validation error for invalid number
  //defined input
  inputDefinedCheck(d,"ffd","Not a valid number");
  //built-in input
  inputBuiltinCheck(d,"ffd","Not a valid number");
  
  //trigger validation error for too large number
  //defined input
  inputDefinedCheck(d,"9999999999999999999","Outside of possible number range");
  //built-in input
  inputBuiltinCheck(d,"9999999999999999999","Outside of possible number range");
  
  //trigger entity validation error 
  //defined input
  inputDefinedCheck(d,"5","must be greater than 10");
  //built-in input
  inputBuiltinCheck(d,"4","must be greater than 10");
 
  d.close();
}

function inputBuiltinCheck(d:WebDriver, input:String, error:String){
  inputCheck(d, input, error, "built-in-");
}
function inputDefinedCheck(d:WebDriver, input:String, error:String){
  inputCheck(d, input, error, "");
}
function inputCheck(d:WebDriver, input:String, error:String, builtin:String){
  var inputelem := d.findElements(SelectBy.className(builtin+"input-elem"))[0];
  inputelem.clear();
  inputelem.sendKeys(input);
  var button := d.findElements(SelectBy.className(builtin+"button-elem"))[0];
  button.click();
  assert(d.getPageSource().contains(error));
}