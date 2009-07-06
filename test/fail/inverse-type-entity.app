//Inverse is only allowed on reference type properties

application test
 
 entity Test {
   test2 :: String (inverse=Test2.test)
 } 
 
 entity Test2{
   test :: String
 }