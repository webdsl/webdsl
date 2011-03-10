application exampleapp

entity Ent {
  i :: Long
  validate(i > 10, "must be greater than 10")
}

var e1 := Ent{ i := 5L }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  output(e.i)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      input(e.i)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
}

var e2 := Ent{ i := 5L }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  output(e.i)
  form{
    "defined input"
    input(e.i)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
}

test inttemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
  
  d.close();
}
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  assert(       input.getValue()=="5");
 
  //add an 8 in the defined input to make 58
  //defined input
  inputDefinedCheck(d,"58","defined output58");
  
  //trigger validation error for invalid number
  //defined input
  inputDefinedCheck(d,"ffd","Not a valid number");
  
  //trigger validation error for too large number
  //defined input
  inputDefinedCheck(d,"999999999999999999999999999999999999999999999999999999999","Outside of possible number range");
  
  //trigger entity validation error 
  //defined input
  inputDefinedCheck(d,"5","must be greater than 10");

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