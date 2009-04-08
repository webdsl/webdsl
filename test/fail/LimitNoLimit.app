//Expression should be of type Int

application test

  entity Entity{
    name :: String
  }
  
  function home(){
    for(e:Entity offset Entity{}){ 
      log(e.name);
    }
  }