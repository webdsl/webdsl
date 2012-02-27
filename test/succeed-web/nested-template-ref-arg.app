application test

page root(){test}

define test(){
  var p := Person{s:=Person{}}
  selectCoauthorFromList(p.s)
}

entity Person{
  s -> Person (not null)
}

define selectPersonFromList(){}

define selectCoauthorFromList(pers : Ref<Person>) {
  selectPersonFromList()
  define selectPersonFromList(){
  	if(pers.getReflectionProperty().hasNotNullAnnotation()){
  	  "123foo"
  	}
  }
}

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  assert(d.getPageSource().contains("123foo"));
}