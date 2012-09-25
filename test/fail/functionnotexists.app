//No function
//No function 'test2' for 'super' with signature test2()
application test

section functions

  entity User {
    name :: String
    function test() {
    	
    }
  }
 
  entity SpecialUser : User {
  	function test2() {
  		super.test2();
  	}
  }

define page root() {
  var u : User := User { name := "hoi"}
  action a() { test(); }
}
