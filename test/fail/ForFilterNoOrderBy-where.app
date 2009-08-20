//should return a boolean

application test

  entity Entity0{
    name :: String
  }
  
  function root(){
    var entList : List<Entity0> := [Entity0{name:="1"},Entity0{name:="2"}];
    
    for(e:Entity0 in entList where "6" limit 6 offset 4){ 
      log(e.name);
    }
  }
