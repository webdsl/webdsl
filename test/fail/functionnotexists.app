//No function or page

application test

section functions

  entity User {
    name :: String
    function test() {
    
    }
  }

define page root() {
  var u : User := User { name := "hoi"}
  action a() { test(); }
}
