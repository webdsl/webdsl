// definition for the validate template 

application test
  
  define validate1(check:Bool,message:String){
    request var errors : List<String> := null
    if(errors != null){
      errorTemplateForm(errors)[all attributes]
    }
    validate{
      if(!check){ 
        errors := [message];
      }
      errors := handleValidationErrors(errors);
    }
  }

  define page root(){
    var i := 0
    form{
      input(i)
      validate1(i>2,"i must be greater than 2")
      submit action{} {"save"}
    }
  }
 