application test

  entity User{
  	name : String
  	pass : String
  	test : Int
  }

  entity Person {
  	desc : Text
  }

  page root(){
  	for(user:User){
      showit(user with name pass test)
  	}

    var u := User{ name := "123" pass := "456" test := 3}

    form{
      testderive(u with name pass test)
      submit action{u.save();}[class="button-test"] { "save" }
    }
    <hr/>
    navigate testperson() { "test Person page" }
  }

  page testperson(){
  	for(person:Person){
      showit(person with desc)
  	}

    var ps := Person{ desc := "123"}

    form{
      testderive(ps with desc)
      submit action{ps.save();} { "save" }
    }
  }

  template testderive(u:e with p){ //,labels:[String]){
    foreach p {
      input(u.p)[class="input-test"]
      "-"
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
