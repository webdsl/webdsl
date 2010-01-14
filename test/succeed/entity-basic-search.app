application basic_search

entity Person {
  fullName :: String (searchable)
}

entity Address {
	street :: String (searchable)
	number :: Int (searchable)
}

entity NotSearchable {
	name :: String
}

define page root () {
	for(p : Person in searchPerson("zef")) {
		output(p.fullName)
	}
	for(p : Address in searchAddress("123")) {
		output(p.street)
		output(p.number)
	}
	
}
