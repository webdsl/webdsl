//Inline templates are disabled

application test

  define page root() {
    block[onclick := action {replace(test,template { "bbb" } );}] { 
      placeholder test {"hoi1"}
    } 
  }
