// a bug in template class lookup caused the input field to disappear 
// when form was submitted and rerendered with validation errors

application exampleapp

define page root() {
  main()
  define body() {
    navigate createPerson(){ "go"}
  }
}

entity Person {

  username    :: String (id, iderror="Username is taken"
                           , idemptyerror="Username may not be empty")

}
 page createPerson(){
              main()
              define body() {
                var temp := Person{}
                form {
                     labeltest("123"){
                       input(temp.username)
                     }
                  action("Save", save())
                }
                action save() {
                  temp.save();
                }
              }
            }

            template main(){
              body
            }
            template body(){

            }


  define labeltest(s:String) {
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

  define labelInternaltest(s:String, tname :String, tc :TemplateContext){

    databind{ getPage().enterLabelContext(tname); }
    validate{ getPage().enterLabelContext(tname); }
    render{   getPage().enterLabelContext(tname); }

    elements()

    databind{ getPage().leaveLabelContext();}
    validate{ getPage().leaveLabelContext();}
    render{   getPage().leaveLabelContext();}
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
  
