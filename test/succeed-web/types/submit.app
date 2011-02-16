application exampleapp

  entity Ent {
    name :: String
  }
  
  var globale := Ent{ name := "the entity" }
  
  define page root(){
    //var tname := "TEST---"+getTemplate().getUniqueId() 
    form{
      input(globale.name)
      submit save() { "save" }
      submitlink save() { "save" } 
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