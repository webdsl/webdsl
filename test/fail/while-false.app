//'while(false)' block is unreachable.

application test

  define page root(){
    action test(){
      while(false){
        log("test");
      }
    }
  }
