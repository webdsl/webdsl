//Function with signature getName() for EntityX overlaps with built-in function.

application test

entity EntityX {

	function getName() : Int {
		return 3;	
	}
	
}

define page root() {

}