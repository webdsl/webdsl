application test

entity A{
  test :: String(name,validate(test.length() >= 4, "property should be atleast 4 chars long") )
}
entity Error{
  message :: String
}

var one := A{ test := "abcd"}
var two := A{ test := "wxyz"}
var three := A { test := "nnnn" }
var four := A{}
var error := Error {}

page root(){
  par{ output("1: " + one.test) }
  par{ output("2: " + two.test) }
  par{ output("3: " + three.test) }
  par{ output("4: " + four.test) }
  par{ output("error: " + error.message) }
  form{
    submit action{
      one.test := "abcde";
      var errors := getStringMessage(commitAndStartNewTransaction());
      error.message := error.message + errors;
      two.test := "xyz";
      var errors1 := getStringMessage(commitAndStartNewTransaction());
      error.message := error.message + errors1;
      three.test := "jjjj";
      var errors2 := getStringMessage(commitAndStartNewTransaction());
      error.message := error.message + errors2;
      four.test := two.test + " makeItLonger" ;
      var errors3 := getStringMessage(commitAndStartNewTransaction());
      error.message := error.message + errors3;
    }[class := "actionb"] { "do Action" }
    
  }
  
  form{
    submit action{
      one.test := "abecd";
      rollbackAndStartNewTransaction();
      two.test := "xyzw";
      four.test := one.test + " makeItLonger" ;
    }[class := "actionc"] { "do Action" }
  }
}

function getStringMessage(errors : List<NativeValidationException>) : String{
  var result := "";
  for(ex : NativeValidationException in errors){
    result := result + " " + ex.getErrorMessage();
  }
  return result;
}

test MultipleTransactions{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  assert(d.getPageSource().contains("1: abcd"), "initvalue");
  assert(d.getPageSource().contains("2: wxyz"), "initvalue");
  assert(d.getPageSource().contains("3: nnnn"), "initvalue");
  assert(d.getPageSource().contains("4: "), "initvalue");
  assert(d.getPageSource().contains("error:"), "initvalue");
  
  var button := d.findElements(SelectBy.className("actionc"))[0];
  button.click();
  
  assert(d.getPageSource().contains("1: abcd"), "rolledback");
  assert(d.getPageSource().contains("2: xyzw"), "normalchange");
  assert(d.getPageSource().contains("4: abcd makeItLonger"), "old value not still in memory");
  
  
  d.get(navigate(root()));
  assert(d.getPageSource().contains("1: abcd"), "initvalue");
  assert(d.getPageSource().contains("2: xyzw"), "initvalue");
  assert(d.getPageSource().contains("3: nnnn"), "initvalue");
  assert(d.getPageSource().contains("4: "), "initvalue");
  assert(d.getPageSource().contains("error: "), "initvalue");
  
  button := d.findElements(SelectBy.className("actionb"))[0];
  button.click();
  
  assert(d.getPageSource().contains("1: abcde"), "changed");
  assert(d.getPageSource().contains("2: xyzw"), "rollback");
  assert(d.getPageSource().contains("3: jjjj"), "changed");
  assert(d.getPageSource().contains("4: xyzw makeItLonger"), "old value not still in memory");
  assert(d.getPageSource().contains("error:  property should be atleast 4 chars long"), "errors");
  
}