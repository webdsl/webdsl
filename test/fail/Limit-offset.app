//Expression should be of type Int

application test

  entity Entity0{
    name :: String
  }
  
  function home(){
    for(e:Entity0 limit 5 offset Entity0{}){ 
      log(e.name);
    }
  }

  define page root() {
  }
