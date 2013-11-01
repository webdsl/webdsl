application exampleapp

  entity Ent {
    name : String
  }
  
  var globale := Ent{ name := "the entity" }
  
  page root(){
    //var tname := "TEST---"+getTemplate().getUniqueId() 
    form{
      input(globale.name)[class="inputname"]
      submit save() [class="savebtn1"] { "save" }
      submitlink save() [class="savebtn2"] { "save" } 
      //wrapsubmit(tname){ submit save() [name = tname] { "save" } }
      //wrapsubmit(tname){ submitlink save() [name = tname] { "save" } }
    }
    action save(){
      validate(globale.name != "", "cannot be empty");
    }
  }
  /*
  define ignore-access-control wrapsubmit(tname:String){
    if(getValidationErrorsByName(tname).length > 0){
      errorTemplateAction(getValidationErrorsByName(tname)){
        elements()
      }
    }
    else{
      elements()
    }
  }*/
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    for(i:Int from 1 to 3){
      clearInput(d);
      clickButton(d,i);
      checkForError(d);
      fillInput(d);
      clickButton(d,i);
      checkForNoError(d);    
    }
  }
  
  function clearInput(d:WebDriver){	d.findElement(SelectBy.className("inputname")).clear(); }
  function fillInput(d:WebDriver){	d.findElement(SelectBy.className("inputname")).sendKeys("123"); }
  function clickButton(d:WebDriver, num:Int){ d.findElement(SelectBy.className("savebtn"+num)).click(); }
  function checkForError(d:WebDriver){ assert(d.getPageSource().contains("cannot be empty")); }
  function checkForNoError(d:WebDriver){ assert(!d.getPageSource().contains("cannot be empty")); }
  