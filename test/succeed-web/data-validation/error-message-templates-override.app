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
  
  test messages {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("foobarbaz"));
    d.close();
  }