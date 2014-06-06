application exampleapp

  entity Ent {
    name :: String
    set -> Set<Ent>
    //list -> List<Ent>
    validate(!(e1 in set), "cannot select e1 in set")
    //validate(!(this in list), "cannot select self in list")
  }

  var e1 := Ent{ name := "e1" }
  var e2 := Ent{ name := "e2" }
  var e3 := Ent{ name := "e3" }
  var e4 := Ent{ name := "e4" }
  var e5 := Ent{ name := "e5" }

  init{
    e1.set := {e2,e3};
    e4.set := {e2,e3};
  }

  page root(){
    testok(e1)

    // the error in the init block of testerror will cause a validation error popup when clicking this link
    // currently not tested because firefox webdriver seems to exit at this point
    navigate testerror() { "page with error" }
  }

  page rootfail(){
    testfail(e1)
  }

  template testok(e:Ent){
    form{
      input(e.set,from Ent)[class = "input-elem"]
      submit action{}[class = "button-elem"]{"save"}
    }
    output(e.set)
  }

  template testfail(e:Ent){
    form{
      input(e.set,from Ent)[class = "input-elem"]
      databind{
        //simulate wrong entry
        e.set.add(e1);
      }
      submit action{}[class = "button-elem"]{"save"}
    }
    output(e.set)
  }

  page testerror(){
    init{
      e1.set.add(e1);
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root()));
    clickButton(d);
    checkForNoError(d);

    d.get(navigate(rootfail()));
    clickButton(d);
    checkForError(d);

  }

  function clickButton(d:WebDriver){ d.findElement(SelectBy.className("button-elem")).click(); }
  function checkForError(d:WebDriver){ assert(d.getPageSource().contains("cannot select e1 in set")); }
  function checkForNoError(d:WebDriver){ assert(!d.getPageSource().contains("cannot select e1 in set")); }
