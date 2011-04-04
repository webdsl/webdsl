//#1 Global variable 'globalVarNoInit' must be initialized
//#2 Global variable with name 'globalVarDouble' is defined multiple times
//#2 Global variable with name 'globalVarRequest' is defined multiple times
//Entity 'EntityDouble' is defined multiple times
//Property 'prop' of entity 'EntityPropDouble' is defined multiple times
//Property 'prop' of entity 'EntityPropDouble2' is defined multiple times
//Function with signature test(Int) of entity 'EntityFuncDouble' is defined multiple times.
//^EntityNoDoubleFunction
//^noMatch
//^EntityOverrideFunction
//Global function with signature globalFunctionDouble(Int) is defined multiple times
//^validExtendFunction
//Extend function with signature globalFunctionExtendNothing() extends a non-existing function
//Extend function with signature InEntityFunctionExtendNothing() in EntityWithFunctionExtendNothing extends a non-existing function
//^globalFunctionAndEntity
//#2 Multiple template definitions with signature templateDouble(Int)
//#2 Multiple page/template definitions with name 'templateDoubleNoArgs'
//#2 Multiple page/template definitions with name 'templatePageClash'
//Email 'emailNameClash' is defined multiple times
//Email 'emailCannotBeOverloaded' is defined multiple times
application test

define page root () { }

entity User {}

var globalVarNoInit : User;

var globalVarDouble : User := User {}
var globalVarDouble : User := User {}

var globalVarRequest : User := User {}
request var globalVarRequest : User := User {}





entity EntityDouble {}
entity EntityDouble {}

entity EntityPropDouble {
  prop :: String
}
extend entity EntityPropDouble {
  prop :: String
}

entity EntityPropDouble1 {
  prop :: String
}
entity EntityPropDouble2 : EntityPropDouble1 {
  prop :: String
}

entity EntityFuncDouble {
  function test(a : Int) {}
}
extend entity EntityFuncDouble {
  function test(b : Int) {}
}

entity EntityNoDoubleFunction {
  function noMatch(a : Int) {}
  function noMatch(a : String) {} 
}

// Overriding a function is permitted
entity EntityBase {
  function noMatch() {}
}
entity EntityOverrideFunction : EntityBase {
  function noMatch() {}
}


extend entity EntityExtendNonExisting {}




function globalFunctionDouble(a : Int) : Int { return 1; }
function globalFunctionDouble(b : Int) : String{ return "a"; }



function validExtendFunction() {}
extend function validExtendFunction() {}

extend function globalFunctionExtendNothing() {}

entity EntityWithFunctionExtendNothing {
  extend function InEntityFunctionExtendNothing() {} 
}



// Should be no problem.
function globalFunctionAndEntity(a : Int) { }
entity globalFunctionAndEntity { }



// double template signature

define templateDouble(i : Int) {}
define templateDouble(j : Int) {}

// top-level name clash

define templateDoubleNoArgs() {}
define templateDoubleNoArgs() {}

define page templatePageClash() {}
define page templatePageClash() { 
  navigate("x", pagenotfound())
}

define email emailNameClash() {from("") to("") subject("")}
define email emailNameClash() {from("") to("") subject("")}

define email emailCannotBeOverloaded(a: Int) {from("") to("") subject("")}
define email emailCannotBeOverloaded(a: String) {from("") to("") subject("")}
