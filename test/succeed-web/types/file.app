application exampleapp

entity Ent {
  f :: File
  validate(f==null || f.fileName().length() > 5, "filename must be longer than 5 characters")
  i :: Image
  validate(i==null || i.fileName().length() > 5, "filename must be longer than 5 characters")
}

  define ignore-access-control inputFile1(f:Ref<File>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    if(errors != null){
      errorTemplateInput(errors){
        inputFileInternal(f,tname)[all attributes]
      }
    }
    else{
      inputFileInternal(f,tname)[all attributes]
    }
    validate{
      errors := f.getValidationErrors();
      errors := handleValidationErrors(errors);  
    }
  }


define ignore-access-control inputFileInternal(f : Ref<File>, tname : String){
  init{
    getPage().formRequiresMultipartEnc := true;
  }
  <input 
    if(getPage().inLabelContext()) { 
      id=getPage().getLabelString() 
    } 
    name=tname 
    type="file"
    class="inputFile "+attribute("class") 
    all attributes except "class"
  />

  databind{
    var fnew : File := getPage().getFileUpload(tname);
    if(fnew != null && fnew.fileName() != ""){
      f := fnew;
    }
  }
}


var e1 := Ent{ }

define page root(){
    "file: "
    form{
      inputFile1(e1.f)
      submit action{} {"save"}
    }
    " "
    output(e1.f)
    
    <br/>
    <br/>
    <br/>
    "image: "
    form{
      inputImage1(e1.i)
      submit action{} {"save"}
    }
    " "
    output(e1.i)
}

define ignore-access-control inputImage1(i : Ref<Image>){
  inputFile1(i as Ref<File>)[all attributes]
}