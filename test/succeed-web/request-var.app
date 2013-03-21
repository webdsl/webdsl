application test

  page root (){
    var v1 : Bool
    request var errors : [String] := List<String> ()

    if(errors.length > 0){ 
      errorTemplateAction (errors) 
    }
    form{
      label ("v1") { input (v1) }
      break
      submit task1 () [class="thebutton"] { "Task 1" }
    }
     
    action task1(){
      validateE (errors, v1, "V1 fails") ;
    }
  }

  function validateE (es : [String], cond : Bool, msg : String){
    if(!cond){
      es.add(msg);
      cancel();
    }
  }
    
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));

    var button := d.findElement(SelectBy.className("thebutton"));
    button.click();

    assert(d.getPageSource().contains("V1 fails"));
  }
