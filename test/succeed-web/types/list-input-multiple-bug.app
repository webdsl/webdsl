//bug in implementation was causing list input to change the list while it was not part of form 

application exampleapp

entity Ent {
    name :: String
    list -> List<Ent>
}

var e1 := Ent{ name := "1" list := [e1,e2] }
var e2 := Ent{ name := "2" }

define page root(){
  form{
    input(e1.list)
    submit action{} [class="button1"] {"save"}
  }
  form{
    input(e2.list)
    submit action{} [class="button2"] {"save"}
  }
  "length:" output(e1.list.length)
}

  test inputajaxtests{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    d.findElement(SelectBy.className("button2")).click();
    assert(d.getPageSource().contains("length:2"));
  }