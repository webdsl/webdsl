application expandtest

expandtemplate pages to Ent {
  page ent( x: Ent ){
    "view page for ents"
    table{
      derive viewRows from x
    }
  }
  page createEnt(){
    var tmp := Ent{}
    form{
      table{
        derive editRows from tmp
      }
      submit action{ tmp.save(); return ent(tmp); } [class="testbutton"] { "save" }
    }
  }
}

expand Person to pages
expand User to pages

entity Person{
  name : String
}
entity User{
  name : String
}

var p1 := Person{}
var u1 := User{}

page root(){
  navigate person(p1) { "view person" }
  navigate createPerson() { "create person" }
  navigate user(u1) { "view user" }
  navigate createUser() { "create user" }
}

test {
  var d := getFirefoxDriver();

  d.get(navigate(createPerson()));
  d.findElement(SelectBy.className("testbutton")).click();
  assert(d.getPageSource().contains("view page for persons"));

  d.get(navigate(createUser()));
  d.findElement(SelectBy.className("testbutton")).click();
  assert(d.getPageSource().contains("view page for users"));
}
