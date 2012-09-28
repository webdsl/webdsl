application test

page root () {
	
}
entity A : B {
	function test1(): String {
		return super.test2();
	}
	function test3 (): String {
		return super.test3();
	}
	function test6() {
		super.name := "test";
	}
}
	
entity B  {
	name :: String
	function test2 (): String {
		return "foo";
	}
	function test3 (): String {
		return "bar";
	}
	
}

test test_super {
	var first := A{};
	var second := B{};
	assert(first.test1() == "foo", "super should point to superClass/in this case same as this");
	
	assert(second.test3()== "bar", "simple methodcall op superClass Entity");
	assert(first.test3() == "bar", "super should point to superClass/in this case it should point to the overloaded method in super");

	assert(first.name == "", "for init prop should be null");
	first.test6();
	assert(first.name == "test", "super can set fields superclass");

}