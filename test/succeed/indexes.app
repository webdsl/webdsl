application attributes

section model

entity x {
	a1 :: String (searchable)
}
entity Y : x{
	a2 :: String (searchable)
}
entity Z : Y{
	a3 :: String (searchable)
}
extend entity x {
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
		searchx("x");
		searchY("x");
		searchZ("x");
		searchExtendIndex("x");
	}
		
}
