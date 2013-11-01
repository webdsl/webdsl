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
    test(e1)
  }

  template test(e:Ent){ 
    form{
      input(e.set,from Ent)[class = "input-elem"] //defined in built-in.app
      submit action{}[class = "button-elem"]{"save"}
    }	
    output(e.set)
  }
  
  page testerror(){ 
  	init{ 
  		e1.set.add(e1);
    }
    test(e1)
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
	  clickButton(d);
    checkForNoError(d);
    
    d.get(navigate(testerror()));
	  clickButton(d);
    checkForError(d);
  }

  function clickButton(d:WebDriver){ d.findElement(SelectBy.className("button-elem")).click(); }
  function checkForError(d:WebDriver){ assert(d.getPageSource().contains("cannot select e1 in set")); }
  function checkForNoError(d:WebDriver){ assert(!d.getPageSource().contains("cannot select e1 in set")); }
    