application exampleapp

entity Ent {
  s::Text
  validate(s.length() > 2, "length must be greater than 2")
}

define ignore-access-control outputText1(s: Text){
  text(s)
}

  define ignore-access-control inputText1(s:Ref<Text>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputTextInternal(s,tname)[all attributes]
      }
    }
    else{
      inputTextInternal(s,tname)[all attributes]
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors := handleValidationErrors(errors);    
    }
  }

define ignore-access-control inputTextInternal(s : Ref<Text>, tname : String){
  var req := getRequestParameter(tname)
  <textarea 
    if(getPage().inLabelContext()) { 
      id=getPage().getLabelString() 
    } 
    name=tname 
    class="inputTextarea inputText "+attribute("class") 
    all attributes except "class"
  >
    if(req != null){ 
      text(req) 
    }
    else{
      text(s)
    }  
  </textarea>

  databind{
    if(req != null){
      s := req;
    }
  }
}

var e1 := Ent{ s := "123" }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  outputText1(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputText1(e.s)[class = "input-elem"]
    }
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.s)
  form{
  "built-in input"
    label(" CLICK ")[class = "built-in-label-elem"]{
      input(e.s)[class = "built-in-input-elem"]
    }
    submit action{}[class = "built-in-button-elem"]{"save"}
  }
}

var e2 := Ent{ s := "123" }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  outputText1(e.s)
  form{
    "defined input"
    inputText1(e.s)[class = "input-elem"]
    submit action{}[class = "button-elem"]{"save"}
  }	
  <br />
  "built-in output"
  output(e.s)
  form{
    "built-in input"
    input(e.s)[class = "built-in-input-elem"]
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
  assert(       input.getValue()=="123");
  assert(builtininput.getValue()=="123");
 
  //correct values
  //defined input
  inputDefinedCheck(d,"1234","defined output1234");
  //built-in input
  inputBuiltinCheck(d,"1234","built-in output1234");
  
  //trigger validation error for property validation (length > 2)
  //defined input
  inputDefinedCheck(d,"a","length must be greater than 2");
  //built-in input
  inputBuiltinCheck(d,"a","length must be greater than 2");

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