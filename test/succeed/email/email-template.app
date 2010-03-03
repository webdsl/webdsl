application test

// Emails and regular templates should be in different namespaces,
// so this should succeed.

define email TestEmail() {
	to("aaa@bbb.com")
	from("tst@webdsl.org")
	subject("Test")
}

define TestEmail() {

}

define page root () {
	submit action{ email(TestEmail()); } {"email"}
	
	TestEmail()
}

