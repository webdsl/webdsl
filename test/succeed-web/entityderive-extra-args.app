application test

  entity User{
  	name : String
  	pass : String
  }

  //entity Person {
  //	desc : Text
  //}

  page root(){
  	for(user:User){
      showit(user with name pass)
  	}

    var u := User{ }

    form{
      testderive(u with name("1","2") pass("3","4"))
      submit action{ u.save(); }[class = "button-test"]{ "save" }
    }
    <hr/>
    //testperson
  }
/*
  template testperson(){
  	for(person:Person){
      showit(person with desc)
  	}

    var ps := Person{ desc := "123"}

    form{
      testderive(ps with desc)
      submit action{ps.save();} { "save" }
    }
  }
*/
  template testderive(u:e with p(label:String, placeholder:String)){ //,labels:[String]){
    foreach p {
      div{
        label(label){ input(u.p)[class="input-test", placeholder=placeholder] }
      }
    }
  }

  template showit(u:e with p){
    foreach p {
      output(u.p)
      "-"
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var inputs := d.findElements(SelectBy.className("input-test"));
    inputs[1].sendKeys("testinputvalue");
    var button := d.findElement(SelectBy.className("button-test"));
    button.click();
    assert(d.getPageSource().contains("testinputvalue"));
  }
