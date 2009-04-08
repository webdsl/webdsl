//Expression should be of type Int

application test

  entity Entity{
    name :: String
  }
  
  function home(){
    for(e:Entity limit 5 offset Entity{}){ 
      log(e.name);
    }
  }