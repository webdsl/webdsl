//Expression should be of type Int

application test

  entity Entity0{
    name :: String
  }
  
  function home(){
    for(e:Entity0 limit "1" offset 3){ 
      log(e.name);
    }
  }

  define page root() {
  }
