//should return a boolean

application test

  entity Entity{
    name :: String
  }
  
  function home(){
    var entList : List<Entity> := [Entity{name:="1"},Entity{name:="2"}];
    
    for(e:Entity in entList where 56.67f){ 
      log(e.name);
    }
  }