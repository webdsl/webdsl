//Cannot override the builtin property 'id'
//Cannot override the builtin property 'version'
//Cannot use the reserved property name 'class'
//Cannot override the builtin property 'created'
//Cannot override the builtin property 'modified'

application test

entity Test {

	id :: String
	version :: String
	class :: String    // would cause name clash with java's getClass()
	created :: String
	modified :: String
}

define page root() { }
