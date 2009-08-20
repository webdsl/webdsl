//should be a collection of type

application test

  entity Entity0{
    name :: String
  }
  
  function home(){
    var entList : List<String> := ["1","2"];
    
    for(e:Entity0 in entList where e.name == "1"){ //type error
      log(e.name);
    }
  }

  define page root() {

  }
