//Duplicate name 'i' in argument list.

// @TODO should check for all 12 occurences, but no counting support in fail tests and position info is stripped from args currently

application test 

define page root() {
}

define page foo1(i:Int, i:String){ output(i+i) }
define foo2(i:Int, i:String){ output(i+i) }
define ajax foo3(i:Int, i:String){ output(i+i) }
function foo4(i:Int, i:String){ var s := i+i; }
function foo5(i:Int, i:String):Bool{ return true; }
predicate foo6(i:Int, i:String){ true }

