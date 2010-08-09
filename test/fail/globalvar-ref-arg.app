//Global variable g1 is not allowed
//Global variable g2 is not allowed

application test

entity Test { name :: String }

var g1 := Test{ name := "1" }
var g2 := Test{ name := "2" }
var g3 := Test{ name := "3" }

define page root(){
  refargtemplate("dfdfss",g1)  
  refargtemplate("dfdfss",global.g2)  
}

define refargtemplate(a:String, b:Ref<Test>){ 
  form{
    input(b)
    submit action{} {"save"}
  }
}