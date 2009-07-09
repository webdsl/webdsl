//No function or page

application test

section functions

  entity User {
    name :: String
    function test() {
    
    }
  }

define page home() {
  var u : User := User { name := "hoi"}
  action a() { test(); }
}
