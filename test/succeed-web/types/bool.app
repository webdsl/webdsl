application exampleapp

entity Bla {
  name :: String
  bla :: Bool
  forceTrue :: Bool
  validate(!forceTrue || bla, "force true was enabled, but value was false")
}


var b1 := Bla{ name := "b1" bla := false forceTrue:=false}
var b2 := Bla{ name := "b2" bla := true forceTrue:=true}

define page root(){
    "regular"
    <br />
    test(b1)
    <br />
    <br />
    <br />
    "validated, must be true"
    <br />
    test(b2)

    <br />
    navigate testnolabel(){ "no label test" }
}

define test(b:Bla){
  output(b.name)
  " defined output"
  output(b.bla)[class = "outputelem"+b.name]
  form{
    "defined input"
    label(" CLICK ")[class = "labelelem"+b.name]{
      input(b.bla)[class = "inputelem"+b.name] //@TODO change to inputBool1 when labels+validation is supported
    }
    submit action{} [class = "savebutton"+b.name] {"save"}
  }
}

test booltemplates {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var input := d.findElement(SelectBy.className("inputelemb1"));
  assert(!input.isSelected());
  var label := d.findElement(SelectBy.className("labelelemb1"));
  label.click();
  assert(input.isSelected());
  var button := d.findElement(SelectBy.className("savebuttonb1"));
  button.click();

  var input2 := d.findElement(SelectBy.className("inputelemb1"));
  assert(input2.isSelected());


  //tests with validation

  var input3 := d.findElement(SelectBy.className("inputelemb2"));
  input3.toggle();
  assert(!input3.isSelected());

  var button3 := d.findElement(SelectBy.className("savebuttonb2"));
  button3.click();

  assert(d.getPageSource().split("force true was enabled, but value was false").length == 2, "didn't find a single validation error for defined bool input");

  testnolabel(d);
}


var b4 := Bla{ name := "b4" bla := true forceTrue:=true}

define page testnolabel(){
  output(b4.bla)[class = "outputelem"]
  form{
    input(b4.bla)[class = "inputelem"]
    submit action{} [class = "savebutton"] {"save"}
  }
}

function testnolabel(d:WebDriver) {
  d.get(navigate(testnolabel()));

  var input := d.findElement(SelectBy.className("inputelem"));
  input.toggle();
  assert(!input.isSelected());

  var button := d.findElement(SelectBy.className("savebutton"));
  button.click();

  assert(d.getPageSource().split("force true was enabled, but value was false").length == 2, "didn't find a single validation error for defined bool input");

}