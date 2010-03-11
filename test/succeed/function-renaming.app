application test

define page root () {
}

function globFunc() {
	func();
	func(33);
	
	var x : Ent;
	x.func();
	x.func(33);
}

function globFunc(i : Int) {
	func();
	func(33);
	
	var x : Ent;
	x.func();
	x.func(33);
}

function func() : Int {
	return 1;
}

function func(i : Int) : Int {
	return 10;
}
function testGlobal() : Int {
		return func() + func(1); // should return 11
}

entity Ent {

	function entFunc() { 
		globFunc();
		globFunc(33);
		entFunc();
		entFunc(33);
	}
	
	function entFunc(i : Int) {
		globFunc();
		globFunc(33);
		entFunc();
		entFunc(33);
	}
	
	function func() : Int {
		return 100;
	}
	function func(i : Int) : Int {
		return 200;
	}
	function test() : Int {
		return func() + func(10);		// should return 300
	}

}

test glob {
	assert(testGlobal() == 11);
}

test ent {
	var x : Ent := Ent{};
	assert(x.test() == 300);
}