application test

  define a(){
    "a"
    b{
      "123"
      elements()
    }
  }
  
  define b(){
    "b"
    elements()
  }
  
  entity Ent {
    i :: Int
  }
  
  var globalent := Ent{}

  define page root(){
    var i := 2
    form{
      a{
        input(i)[class:="input1"]
        submit save()[class:="savebutton"]{ "save" }
      }
    }
    action save(){
      globalent.i := i;
    }
    for(en : Ent){
      output(en.i)
    }
  }

  test {
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));

    var input1 := d.findElements(SelectBy.className("input1"))[0];
    input1.sendKeys("numberone");
    var button := d.findElements(SelectBy.className("savebutton"))[0];
    button.click();
    assert(d.getPageSource().contains("numberone"));
  }

  