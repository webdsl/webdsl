application attributes

section model

entity X {
	a1 :: String (searchable)
}
entity Y : X{
	a2 :: String (searchable)
}
entity Z : Y{
	a3 :: String (searchable)
}
extend entity X {
	b1 :: String (searchable)
}
extend entity Y {
	b2 :: String (searchable)
}


entity ExtendIndex {
}
extend entity ExtendIndex {
	prop :: String (searchable)
}

// TODO: check string: 
//			String[] searchFields = {"a3", "b2", "a2", "b1", "a1"};
//	in file
//			utils.GlobalFunctions.java, function searchZ_

define page root() {
	
	action test() {
		var x1 := searchX("x");
		var x2 := searchY("x");
		var x3 := searchZ("x");
		var x4 := searchExtendIndex("x");
	}
		
}
