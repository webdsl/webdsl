application exampleapp

define page root() {
  form{
    for(p:Person){
      radio(p.relation,from Person)
      radio(p.relbla,from Bla)
    } separated-by{<br />}
    submit action{} [class="savebutton"]{"save"}
  }
  <br />
  for(p:Person){
    output(p.relation)
    output(p.relbla)
  }separated-by{<br />}
  
  navigate test2(){"test page"}
}

entity Person {
  name    :: String
  relation -> Person
  relbla -> Bla
}

entity Bla {
  name :: String
}

var b1 := Bla{ name := "b1" }
var b2 := Bla{ name := "b2" }

var p1 := Person{ name := "p1" }
var p2 := Person{ name := "p2" }
var p3 := Person{ name := "p3" }
var p4 := Person{ name := "p4" }

entity User {
  name :: String
  person1 -> Person
  person2 -> Person
  validate(person1 == null || person1 != person2, "cannot choose same person")
}

var u1 := User{ name := "p1" }
var u2 := User{ name := "p2" }

define page test2(){
  form{
    for(u:User){
      radio(u.person1,from Person)
      radio(u.person2,from Person)
    } separated-by{<br />}
    submit action{} [class="savebutton"]{"save"}
  }
}

test {
  var d : WebDriver := getFirefoxDriver();

  d.get(navigate(root()));  
  // for each person select itself as relation
  var i := 0;
  for(p:Person in [p1,p2,p3,p4]){
    getRadioButtons(d,p.name)[i].click();
    i := i+1;
  }
  for(w:WebElement in getRadioButtons(d,"b1")){
    w.click();
  }
  d.findElement(SelectBy.className("savebutton")).click();
  assert(/p1b1.+p2b1.+p3b1.+p4b1/.find(d.getPageSource()));

  d.get(navigate(test2()));  
  var i2 := 0;
  for(u:User in [u1,u2]){
    getRadioButtons(d,u.name)[i2].click();
    getRadioButtons(d,u.name)[(i2+1)].click(); //TODO parse error without parentheses, likely priority bug
    i2 := i2+2;
  }
  d.findElement(SelectBy.className("savebutton")).click();
  assert(d.getPageSource().split("cannot choose same person").length == 5);
}

function getRadioButtons(d:WebDriver, label:String) : List<WebElement>{
  //css matching not possible on nested text, using xpath
  return d.findElements(SelectBy.xpath("//label[contains(text(),'"+label+"')]/input[1]"));
}
