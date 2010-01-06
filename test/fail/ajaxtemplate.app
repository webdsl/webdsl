//An ajax-enabled template must be called here

application test

  define page root() {
    block[onclick := action {replace(test,bla(4));}] { 
      placeholder test {"hoi1"}
    } 
  }
  
  define bla(i:Int){
    output(i)
  }