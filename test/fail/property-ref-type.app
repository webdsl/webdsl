//Reference type is not allowed as type


application test

entity Test {

	test -> Ref<Test>
	
}

define page root() { }
