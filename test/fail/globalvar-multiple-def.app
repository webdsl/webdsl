//is defined multiple times

application test

entity Test {
  
}

entity Test2 {
  
}

var one : Test := Test{}
var one : Test := Test {}
var two : Test := Test {}
var two : Test2 := Test2 {}


define page root(){}