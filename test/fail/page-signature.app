//There is no page with signature test(String).
application test

define page root () {

	navigate(test("a","b")) { }
	navigate(test("a")) { }
}

define page test(a : String, b : String) { } 
