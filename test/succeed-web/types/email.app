application exampleapp

entity Ent {
  s::Email (not empty)
  validate(s.length() <15, "length must be less than 15")
}


var e1 := Ent{ s := "123@123.123" }

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

var e2 := Ent{ s := "123@123.123" }

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

test {
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
  assert(       input.getValue()=="123@123.123");
 
  //correct values
  //defined input
  inputDefinedCheck(d,"abc@abc.abc","defined outputabc@abc.abc");
  
  //trigger validation error for property validation (length > 2)
  //defined input
  inputDefinedCheck(d,"aghgfdhdhgdfhgfdhdfhdfhfghdhgdfhgdh@a.abc","length must be less than 15");
  
  //invalid format
  //defined input
  inputDefinedCheck(d,"aa.abc","Not a valid email address");
  
  //empty
  //defined input
  inputDefinedCheck(d,"","Value is required");

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

