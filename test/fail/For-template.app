//should be a collection of type

application test

  entity Entity{
    name :: String
  }
  
  define page home(){
    var entList : List<String> := ["1","2"]
    
    for(e:Entity in entList where e.name == "1"){ //type error
      output(e.name)
    }
  }