application test

  define email testemail(to:String,from:String,subject:String) {
    to(to)
    from(from)
    subject(subject)
    "hallo lieve mensen"
    	navigate(test()){"the link"}
    }
    
    page root() {
    	init{securityContext.principal := p2;}
    	output(securityContext.principal.name)
    	
    	rawoutput(body.content)
    	submit action {body.content := renderemail(testemail("1","2","3")).body;}[class:="mailb"]{"create mail"}
    }
    
var p1 := Person{
	name := "A"
}    
var p2 := Person {
	name := "Bassie"
}
entity Person {
	name :: String
	password :: Secret
}
entity Temp {
	content :: String
}

var body := Temp {
	content := "leeg"
}
principal is Person with credentials name, password

page test(){
	
}

test emailNavigate {
	var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("Bassie"),"Bassie should be logged in");
    d.get(navigate(test()));
    assert(d.getPageSource().contains("Access Denied"),"Bassie should not have access to test");
    d.get(navigate(root()));
   	
    var button := d.findElements(SelectBy.className("mailb"))[0];
    button.click();
    assert(d.getPageSource().contains("/test"), "there should be a link");
    assert(d.getPageSource().contains("the link"), "there should be a link");
}

access control rules {
	rule page root(){
		true
	}
	rule page test(){
		securityContext.principal.name == "A"
	}
}

