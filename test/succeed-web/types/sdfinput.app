application test
         
define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  output(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputSDF(e.s,"sdfinputexamplelang")[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
}
 
 entity Ent {
  s::Text
  validate(s.length() > 2, "length must be greater than 2")
}

var e1 := Ent{ s := "abc" }
var e2 := Ent{ s := "abc" }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  output(e.s)
  form{
    "defined input"
    inputSDF(e.s,"sdfinputexamplelang")[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
}

define page atermtest(){
  var a : ATerm := "Foo(Bar(),[1,2,3])".parseATerm() 
  output(a)
}

test sdftemplates {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  
  var input        := d.findElements(SelectBy.className(         "input-elem"))[0];
  var label        := d.findElements(SelectBy.className(         "label-elem"))[0];
  assert(input.getAttribute("id")==label.getAttribute("for"));
  
  commonTest(d);
  
  d.get(navigate(nolabel()));
  commonTest(d);
  
  d.get(navigate(atermtest()));
  assert(d.getPageSource().contains("Foo(Bar,[1,2,3])"));
}
  
function commonTest(d:WebDriver){  
  var input := d.findElement(SelectBy.className("input-elem"));
  assert(input.getAttribute("value")=="abc");
  //correct values
  //defined input
  inputCheck(d,"ab","Unexpected end of file");
  //trigger validation error for property validation (length > 2)
  //defined input
  inputCheck(d,"ac","length must be greater than 2");

}

function inputCheck(d:WebDriver, input:String, error:String){
  var inputelem := d.findElements(SelectBy.className("input-elem"))[0];
  inputelem.clear();
  inputelem.sendKeys(input);
  var button := d.findElements(SelectBy.className("button-elem"))[0];
  button.click();
  assert(d.getPageSource().contains(error));
}
