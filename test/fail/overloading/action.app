//action with name 'send' defined multiple times
application rename

define page root() {
}

define template a() {
	action send(s : String) {
	}	

	define template b__x() {
		action send() { }
		submit("1", send("abc"))
	}
}
