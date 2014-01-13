application test


page root(){	
	if( true ){ "1" }
	if( false ){ } else { "2" }	
	if( false ){ } else if( true ){ "3" }	
	if( false ){ } else if ( false ) { } else { "4" }	
	if( false ){ } else if ( true ) { "5" } else { }	
}

test {
	var d : WebDriver := getFirefoxDriver();

	d.get(navigate(root()));
	assert(d.getPageSource().contains("12345"), "incorrect output");
}


