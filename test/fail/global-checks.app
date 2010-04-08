//Global variable 'globalVarNoInit' must be initialized
//Global variable with name 'globalVarDouble' is defined multiple times
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
//Template with signature templateDouble(Int) is defined multiple times
//Multiple definitions with name 'templateDoubleNoArgs'
//Multiple definitions with name 'templatePageClash'
application test

define page root () { }

entity User {}

var globalVarNoInit : User;

var globalVarDouble : User := User {}
var globalVarDouble : User := User {}




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

define templatePageClash() {}
define page templatePageClash() {
  navigate("x", pagenotfound())
}
