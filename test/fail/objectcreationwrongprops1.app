//does not contain a property
application test

  entity Person {
    name :: String
    tag :: String
    val :: Int
  }
  
  function createPerson(){
    var p: Person := Person { t4g := "1" };

  }