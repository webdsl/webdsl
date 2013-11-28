/**
 *  Test entity save validation in init block of a page
 *  http://yellowgrass.org/issue/WebDSL/698
 */

application input

  entity A {
    name  : String
    title : String := "THE-ERROR"
    
    
    validate(name.length() > 5, "name should be at least 5 characters")
  }
  
  define page root() {
  	var newA : A
  	init{
  		newA := A{ name := "" };
  		newA.save();
  	}
    title{ "root" }
    
    
    output(newA.title)
  }
  
  test pageInitValidate {
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    var alert := d.getAlert();
    assert(alert != null,  "Alert should popup with entity validation errors");
    
    if (alert != null ){
    	assert(alert.getText().contains("should be at least 5 characters"),  "Alert should popup with entity validation errors");
    	alert.accept();
    }
  }
