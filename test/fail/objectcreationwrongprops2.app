//is incompatible with type of entity property
application test

  entity Person {
    name :: String
    tag :: String
    val :: Int
  }
  
  function createPerson(){

    var p: Person := Person { val := "1" };
  }