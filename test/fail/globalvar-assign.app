//Assignment to global variable 'one' is not allowed

application test

entity Test {
  
}

entity Test2 {
  
}

var one : Test := Test{}
var two : Test := Test {}


define page root(){}

function foo(){
  one := Test{};

}