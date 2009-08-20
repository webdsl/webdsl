application test

section atest

entity User {
	name :: String
}

entity Admin: User {
	ismod :: Bool
}

define page root(){
	var u1: User := User{ name := "ikke"}
	var u2: Admin := Admin{ismod := true }
	first(User,Admin, u1, u2)
}


define first(T : EntityType,	Y: EntityType, obj1 : T, obj2 : Y) {
/*  var us : User := User{} //obj1 as User;
	var a : T	:= us as T;

	user(a as User)
	var b : T := obj2 as T;
	var c : T := T{}
*/	var e : T := Y{} as T;
}

define user(u: User) {
	out(u.name)
}

