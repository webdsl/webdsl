//Inverse not allowed between types
//Inverse is only allowed on reference type properties
//TTest2.tes does not exist

application test

  entity Conference {
    proceedings : {Proceedings} (inverse=conference)
  }
  entity Proceedings : Collection {
    conference : String
  }
  entity Collection {
 
  }

 
  entity Test {
    test2 : String (inverse = test)
  }
  entity Test2{
    test : String
  }
 
 
  entity TTest {
    test2 : TTest2 (inverse = tes)
  } 
  entity TTest2{
    test : Test
  }
  
  
  page root(){}