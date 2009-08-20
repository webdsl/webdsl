application test

section atest

entity User {
	name :: String
}

define page root(){
	var u1: User := User{ name := "ikke"}
	first(User, u1)
}


define first(T : EntityType	, obj1 : T) {
	var a : T	:= obj1 					
	output(a)
}

define page user(u: User) {
	out(u.name)
}

