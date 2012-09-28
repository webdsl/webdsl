// http://yellowgrass.org/issue/WebDSL/603

application exampleapp

page root(){}
entity User {}
entity SpecialUser : User{}

test getTypeString {
	var one := User{};
	var two := SpecialUser{};

	assert(one.getTypeString() == "User", "type of User should be User");
	assert(two.getTypeString() == "SpecialUser", "type of SpecialUser should be SpecialUser");
	assert(newUser().getTypeString() == "User", "getTypeString should also be applicable on something else then var");
}

function newUser() : User{
	return User{};
}