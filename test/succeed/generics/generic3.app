application test

section atest

entity User {
	name :: String
}

define page root(){
	var u1: User := User{ name := "ikke"}
	first(User, u1)
}


define first(T : EntityType, obj1 : T) {
	var a : List<T> := List<T>( obj1 )
	var b : List<T> := [ obj1 ]
	second(T, a)	
	second(T, b)
}

define second(T: EntityType, list: List<T>) {
	output(list)
}

define page user(u: User) {
	out(u.name)
}

