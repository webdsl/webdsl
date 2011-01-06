application exampleapp

entity Ent {
  s::URL
  validate(s.length() > 2, "length must be greater than 2")
}

define ignore-access-control outputURL1(s: URL){
  navigate url(s) [all attributes] { url(s) }
}

  define ignore-access-control inputURL1(s:Ref<URL>){
    var tname := getUniqueTemplateId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputURLInternal(s,tname)[all attributes]
      }
    }
    else{
      inputURLInternal(s,tname)[all attributes]
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      if(errors != null && errors.length > 0){
        if(inLabelContext()){ //this adds errors to labels instead
          for(s:String in errors){
            addLabelError(s);
          }
          errors := null;
        }
        cancel();
      }      
    }
  }

define ignore-access-control inputURLInternal(s : Ref<URL>, tname : String){
  var req := getRequestParameter(tname)
  <input 
    if(inLabelContext()) { 
      id=getLabelString() 
    } 
    name=tname 
    type="text"
    if(req != null){ 
      value = req 
    }
    else{
      value = s
    }
    class="inputURL "+attribute("class") 
    all attributes except "class"
  />

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
  outputURL1(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputURL1(e.s)[class = "input-elem"]
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
  outputURL1(e.s)
  form{
    "defined input"
    inputURL1(e.s)[class = "input-elem"]
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

test templates {
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
  inputDefinedCheck(d,"1234","1234</a>");
  //built-in input
  inputBuiltinCheck(d,"1234","1234</a>");
  
  //trigger validation error for too long value
  //defined input
  inputDefinedCheck(d,"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234512345123451234512345123451234512345123451234512345X","exceeds maximum length");
  //built-in input
  inputBuiltinCheck(d,"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234512345123451234512345123451234512345123451234512345X","exceeds maximum length");
  
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