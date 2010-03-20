//Cannot override the builtin property 'id'
//Cannot override the builtin property 'version'
//Cannot use the reserved property name 'class'

application test

entity Test {

	id :: String
	version :: String
	class :: String    // would cause name clash with java's getClass()
	
}

define page root() { }
