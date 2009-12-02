//Global variable 'one' may not be deleted

application test

entity Test {
  
}

entity Test2 {
  
}

var one : Test := Test{}
var two : Test := Test {}


define page root(){}

function foo(){
  global.one.delete();

}