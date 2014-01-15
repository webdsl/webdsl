application test


page root(){	
	if( true ){ "1" }
	if( false ){ } else { "2" }	
	if( false ){ } else if( true ){ "3" }	
	if( false ){ } else if ( false ) { } else { "4" }	
	if( false ){ } else if ( true ) { "5" } else { }
	
	if( false ){ } else if ( false ) { } else if (true) { "6" }
	
	if( false ){ } else if ( false ) { } else if (false) { } else{ "7" }
	if( false ){ } else if ( false ) { } else if (false) { } else if(true) { "8"} else {}
}

test {
	var d : WebDriver := getFirefoxDriver();

	d.get(navigate(root()));
	assert(d.getPageSource().contains("12345678"), "incorrect output");
}


