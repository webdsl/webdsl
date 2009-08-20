application test

section atest

entity User {
	name :: String
}

define page root(){
	var u1: List<User> := [ User{ name := "ikke"} ]
	first(User, u1)
}


define first(T : EntityType, obj1 : List<T>) {
	var a : List<T>	:= obj1 
	for(b: T in a) {
		output(a)
	}
	output(a)
}

define page user(u: User) {
	out(u.name)
}

