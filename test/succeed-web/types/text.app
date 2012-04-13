application exampleapp

entity Ent {
  s::Text
  validate(s.length() > 2, "length must be greater than 2")
}

var e1 := Ent{ s := "123" }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  output(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      input(e.s)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
}

var e2 := Ent{ s := "123" }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  output(e.s)
  form{
    "defined input"
    input(e.s)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
}

test texttemplates {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  
  var input        := d.findElements(SelectBy.className(         "input-elem"))[0];
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
}
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElements(SelectBy.className(         "input-elem"))[0];
  assert(       input.getValue()=="123");
 
  //correct values
  //defined input
  inputDefinedCheck(d,"1234","defined output1234");
  
  //trigger validation error for property validation (length > 2)
  //defined input
  inputDefinedCheck(d,"a","length must be greater than 2");

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