application exampleapp

entity Ent {
  s::Email (not empty)
  validate(s.length() <15, "length must be less than 15")
}

define ignore-access-control outputEmail1(s: Email){
  text(s)
}

  define ignore-access-control inputEmail1(s:Ref<Email>){
    var tname := getUniqueTemplateId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputEmailInternal(s,tname)[all attributes]
      }
    }
    else{
      inputEmailInternal(s,tname)[all attributes]
    }
    validate{
      if(req != null){
        if(!(req as Email).isValid()){
          errors := ["Not a valid email address"];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := s.getValidationErrors();
      }
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

define ignore-access-control inputEmailInternal(s : Ref<Email>, tname : String){
  var req := getRequestParameter(tname)
  <textarea 
    if(inLabelContext()) { 
      id=getLabelString() 
    } 
    name=tname 
    class="inputEmailarea inputEmail "+attribute("class") 
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

var e1 := Ent{ s := "123@123.123" }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  outputEmail1(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputEmail1(e.s)[class = "input-elem"]
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

var e2 := Ent{ s := "123@123.123" }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  outputEmail1(e.s)
  form{
    "defined input"
    inputEmail1(e.s)[class = "input-elem"]
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
  assert(       input.getValue()=="123@123.123");
  assert(builtininput.getValue()=="123@123.123");
 
  //correct values
  //defined input
  inputDefinedCheck(d,"abc@abc.abc","defined outputabc@abc.abc");
  //built-in input
  inputBuiltinCheck(d,"abc@abc.abc","built-in outputabc@abc.abc");
  
  //trigger validation error for property validation (length > 2)
  //defined input
  inputDefinedCheck(d,"aghgfdhdhgdfhgfdhdfhdfhfghdhgdfhgdh@a.abc","length must be less than 15");
  //built-in input
  inputBuiltinCheck(d,"aghgfdhdhgdfhgfdhdfhdfhfghdhgdfhgdh@a.abc","length must be less than 15");
  
  //invalid format
  //defined input
  inputDefinedCheck(d,"aa.abc","Not a valid email address");
  //built-in input
  inputBuiltinCheck(d,"aa.abc","Not a valid email address");
  
  //empty
  //defined input
  inputDefinedCheck(d,"","Value is required");
  //built-in input
  inputBuiltinCheck(d,"","Value is required");

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

