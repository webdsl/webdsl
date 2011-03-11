module lib

  define ignore-access-control errorTemplateInput(messages : List<String>){
    elements()
    for(ve: String in messages){
      block()[style := "width:100%; clear:left; float:left; color: #FF0000;"]{
        output(ve)
      }
    }
  }