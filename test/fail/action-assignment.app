// Cannot use action x() as an expression.
application test

define page root() {

	var z := x()

	action x() {
	
	}
}
