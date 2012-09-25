application test

page root () {
	
}
entity A : B {
	function test(): String {
		return super.test2();
	}
}
	
entity B  {
	function test2 () : String {
		return "foo";
	}
}