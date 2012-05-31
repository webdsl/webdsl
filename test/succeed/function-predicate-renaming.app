application test

define page root () {
}

entity Ent {
}

entity A{
	function mayView(e : Ent) : Bool{
		return true;
	}
}
entity B{
	function mayView(e : Ent) : Bool{
		return false;
	}
}

entity C{
	function mayView(e : Ent) : Bool{
		return true;
	}
}

predicate mayView() {
  true
}

function mayView(e : Ent) : Bool {
	return false;
}

test sameName {
	var e : Ent := Ent{};
	var x : Bool := A{}.mayView(e);
	var y : Bool := B{}.mayView(e);
	var z := C{}.mayView(e);
	
	assert(x == true);
	assert(y == false);
	assert(z == true);
}