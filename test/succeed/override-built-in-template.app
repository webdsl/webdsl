application test

  define override body(){
    "34"
  }

  define override main(){
    "12"
  }
  

  define override errorTemplateInput(messages : List<String>){
    "56"
  }

  define override errorTemplateForm(messages : List<String>){
    "7"
  }

  define override errorTemplateAction(messages : List<String>){
    "8"
  }

  define override templateSuccess(messages : List<String>){
    "9"
  }  

  define page root(){
  }
  
  define run(){
    main
    body
    errorTemplateInput([""])
    errorTemplateForm([""])
    errorTemplateAction([""])
    templateSuccess([""])
  }
  
  test {
  	var r := rendertemplate(run());
  	log("r ="+r+".");
  	log(r);
    assert(r=="123456789");
  }
  
  derive CRUD Foo
  entity Foo{}