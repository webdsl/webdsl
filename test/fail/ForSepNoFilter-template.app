//should be a collection of type

application test

  entity Entity0{
    name :: String
  }
  
  define page root(){
    var entList : List<String> := ["1","2"]
    
    for(e:Entity0 in entList){ //type error
      output(e.name)
    } separated-by { ", " }
  }
