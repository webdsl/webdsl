application test

section atest

entity User {
	name :: String
}

define page home(){
	var u1: User := User{ name := "ikke"}
	first(User, u1)//, viewUser)
}


define first(T : EntityType
					, obj1 : T
//					, viewer:  Template<T>
					) {
	var a : T	:= obj1 					//here T is used as aType
	//second(T,a) //, viewer) 				//here T is as a variable
	output(a)
}

define second(Y : EntityType, obj : Y )//, viewer : Template<T>) 
{
	//viewer(obj)
}

define page user(u: User) {
	out(u.name)
}

