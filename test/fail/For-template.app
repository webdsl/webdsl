//should be a collection of type

application test

  entity Entity2{
    name :: String
  }
  
  define page root(){
    var entList : List<String> := ["1","2"]
    
    for(e:Entity2 in entList where e.name == "1"){ //type error
      output(e.name)
    }
  }
