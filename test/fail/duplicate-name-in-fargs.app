//#14 Duplicate name 'i' in argument list.

application test 

define page root() {
  action a(i: Int , i:String){}
}

define page foo1(i:Int, i:String){ output(i+i) }
define foo2(i:Int, i:String){ output(i+i) }
define ajax foo3(i:Int, i:String){ output(i+i) }
function foo4(i:Int, i:String){ var s := i+i; }
function foo5(i:Int, i:String):Bool{ return true; }
predicate foo6(i:Int, i:String){ true }

