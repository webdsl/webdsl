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
   
    assert(!d.getPageSource().contains("THE-ERROR"), "entity `newA` should not have been saved because of validation error in the init-block of the root page");
  }
