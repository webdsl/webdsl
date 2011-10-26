application testoverrides

  define override errorTemplateInput(messages : List<String>){
      for(ve: String in messages){
          text(ve)
      }
  } 
    
  define override errorTemplateForm(messages : List<String>){
      for(ve: String in messages){
          text(ve)
      }
  }

  define override errorTemplateAction(messages : List<String>){
      for(ve: String in messages){
          text(ve)
      }
  }
      
  define page root(){
    errorTemplateInput(["foo"])
    errorTemplateForm(["bar"])
    errorTemplateAction(["baz"])
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("foobarbaz"));
  }