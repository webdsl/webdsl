application exampleapp

  entity Ent {
    s::WikiText
    validate(s.length() > 2, "length must be greater than 2")
  }

  define ignore-access-control outputWikiText1(s: WikiText){
    rawoutput(s.format())
  }

  define ignore-access-control inputWikiText1(s:Ref<WikiText>){
    var tname := getUniqueTemplateId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputWikiTextInternal(s,tname)[all attributes]
      }
    }
    else{
      inputWikiTextInternal(s,tname)[all attributes]
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

define ignore-access-control inputWikiTextInternal(s : Ref<WikiText>, tname : String){
  var req := getRequestParameter(tname)
  <textarea 
    if(inLabelContext()) { 
      id=getLabelString() 
    } 
    name=tname 
    class="inputTextarea inputWikiText "+attribute("class") 
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

var e1 := Ent{ s := "*1*<b>2</b>" }

define page root(){
    test(e1)
}

define test(e:Ent){ 
  " defined output"  
  outputWikiText1(e.s)
  form{
    "defined input"
    label(" CLICK ")[class = "label-elem"]{
      inputWikiText1(e.s)[class = "input-elem"]
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

var e2 := Ent{ s := "*1*<b>2</b>" }

define page nolabel(){
  testnolabel(e2)
}

define testnolabel(e:Ent){ 
  " defined output"  
  outputWikiText1(e.s)
  form{
    "defined input"
    inputWikiText1(e.s)[class = "input-elem"]
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
  assert(       input.getValue()=="*1*<b>2</b>");
  assert(builtininput.getValue()=="*1*<b>2</b>");
 
  //correct values
  //defined input
  inputDefinedCheck(d,"*1*<b>2</b>",["<em>1</em>","<b>2</b>"]);
  //built-in input
  inputBuiltinCheck(d,"*1*<b>2</b>",["<em>1</em>","<b>2</b>"]);
  
  //trigger validation error for property validation (length > 2)
  //defined input
  inputDefinedCheck(d,"a","length must be greater than 2");
  //built-in input
  inputBuiltinCheck(d,"a","length must be greater than 2");
  
  //test filtering of unsafe tags
  //defined input
  inputDefinedCheck(d,"*1*<b>2</b><script></script>",["<em>1</em>","<b>2</b>"], ["<script>"]);
  //built-in input
  inputBuiltinCheck(d,"*1*<b>2</b><script></script>",["<em>1</em>","<b>2</b>"], ["<script>"]);  

}

function inputBuiltinCheck(d:WebDriver, input:String, error:List<String>){
  inputCheck(d, input, error, "built-in-", List<String>());
}
function inputDefinedCheck(d:WebDriver, input:String, error:List<String>){
  inputCheck(d, input, error, "", List<String>());
}
function inputBuiltinCheck(d:WebDriver, input:String, error:List<String>, shouldnotcontain : List<String>){
  inputCheck(d, input, error, "built-in-", shouldnotcontain);
}
function inputDefinedCheck(d:WebDriver, input:String, error:List<String>, shouldnotcontain : List<String>){
  inputCheck(d, input, error, "", shouldnotcontain);
}
function inputBuiltinCheck(d:WebDriver, input:String, error:String){
  inputCheck(d, input, [error], "built-in-", List<String>());
}
function inputDefinedCheck(d:WebDriver, input:String, error:String){
  inputCheck(d, input, [error], "", List<String>());
}
function inputCheck(d:WebDriver, input:String, errors:List<String>, builtin:String, shouldnotcontain:List<String>){
  var inputelem := d.findElements(SelectBy.className(builtin+"input-elem"))[0];
  inputelem.clear();
  inputelem.sendKeys(input);
  var button := d.findElements(SelectBy.className(builtin+"button-elem"))[0];
  button.click();
  for(error:String in errors){
    assert(d.getPageSource().contains(error),"error: "+error+" not found in: "+d.getPageSource());
  }
  for(notcontain :String in shouldnotcontain){
    assert(!d.getPageSource().contains(notcontain),"should not contain: "+notcontain+" but was found in: "+d.getPageSource());
  }
}