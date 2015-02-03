// a bug in template class lookup caused the input field to disappear
// when form was submitted and rerendered with validation errors
// labelcolumnstest adds another local redefine compared to test local-template-lookup-bug.app

application exampleapp

page root() {
  navigate createPerson() {"go"}
}

entity Person {
  username    : String (id, iderror="Username is taken"
                          , idemptyerror="Username may not be empty")
}

page createPerson(){
  body()
  template body() {
    var temp := Person{}
    form {
      labelcolumnstest("123"){
        input(temp.username)
      }
      submit save() { "Save" }
    }
    action save() {
      temp.save();
    }
  }
}

template body(){ "global body not used" }

template labelcolumnstest(s:String){
  labeltest(s)[all attributes]{
    elements()
  }
  template labelInternaltest(s1:String, tname :String, tc :TemplateContext){
    "override for labelInternaltest"
    output("s:"+s)
    output("s1:"+s1)
    elements()
  }
}

template labeltest(s:String) {
  var tname := getTemplate().getUniqueId()
  request var errors : List<String> := null
  request var tc := getPage().getTemplateContext().clone()

  if(errors != null && errors.length > 0){
    errorTemplateInput(errors){
      labelInternaltest(s,tname,tc)[all attributes]{
        elements()[templateContext=tc]
      }
    }
  }
  else{
    labelInternaltest(s,tname,tc)[all attributes]{
      elements()[templateContext=tc]
    }
  }
  validate{
    errors := getPage().getValidationErrorsByName(tname);
  }
}

template labelInternaltest(s:String, tname :String, tc :TemplateContext){
  "global labelInternaltest not used here"
}

test var {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(createPerson()));
  var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
  assert(elist.length == 2, "expected 2 <input> elements");

  d.getSubmit().click();

  var elist2 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
  assert(elist2.length == 2, "expected 2 <input> elements");
}
