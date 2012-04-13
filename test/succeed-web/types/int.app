application exampleapp

entity Ent {
  i :: Int
  validate(i > 10, "must be greater than 10")
}

var e1 := Ent{ i := 5 }

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

var e2 := Ent{ i := 5 }

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
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  
  var input     :WebElement   := d.findElement(SelectBy.className(         "input-elem"));
  var label        := d.findElement(SelectBy.className(         "label-elem"));
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
}
  
function commonTest(d:WebDriver){  
  var input     :WebElement   := d.findElement(SelectBy.className("input-elem"));
  assert(       input.getAttribute("value")=="5");
 
  //add an 8 in the defined input to make 58
  //defined input
  inputCheck(d,"58","defined output58");
  
  //trigger validation error for invalid number
  //defined input
  inputCheck(d,"ffd","Not a valid number");
  
  //trigger validation error for too large number
  //defined input
  inputCheck(d,"9999999999999999999","Outside of possible number range");
  
  //trigger entity validation error 
  //defined input
  inputCheck(d,"5","must be greater than 10");

}

function inputCheck(d:WebDriver, input:String, error:String){
  var inputelem := d.findElement(SelectBy.className("input-elem"));
  inputelem.clear();
  inputelem.sendKeys(input);
  var button := d.findElement(SelectBy.className("button-elem"));
  button.click();
  assert(d.getPageSource().contains(error));
}