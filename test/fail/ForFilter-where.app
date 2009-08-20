//should return a boolean

application test

  entity Entity2{
    name :: String
  }
  
  function root(){
    var entList : List<Entity2> := [Entity2{name:="1"},Entity2{name:="2"}];
    
    for(e:Entity2 in entList where e.name order by e.name limit 5){ 
      log(e.name);
    }
  }
