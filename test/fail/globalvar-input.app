//Global variable g1 is not allowed in inputs
//Global variable g2 is not allowed in inputs

application test

entity Test { name :: String }

var g1 := Test{ name := "1" }
var g2 := Test{ name := "2" }
var g3 := Test{ name := "3" }

define page root(){
  form{
    input(g1)
    input(global.g2)
    submit action{} {"save"}
  }
}
