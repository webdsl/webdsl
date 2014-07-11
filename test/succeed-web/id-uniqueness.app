//http://yellowgrass.org/issue/WebDSL/809
application id

  entity Project{
    name : String (id, iderror="Project name already exists."
                     , idemptyerror="Please enter a project name.")
  }

  page root(){
    for(pr:Project ){
      div{ output(pr.name) }
    }
    var p := Project{}
    form{
      input(p.name)[placeholder="Enter project name", class="testinput"]
      submit action{ p.save(); } [class="testbutton"] { "Create Project" }
    }
  }

  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    tryCreateX(d);
    tryCreateX(d);
    assert(d.getPageSource().contains("Project name already exists."));
  }
  
  function tryCreateX(d:WebDriver){
  	var input := d.findElement(SelectBy.className("testinput"));
    input.sendKeys("X");
    var button := d.findElement(SelectBy.className("testbutton"));
    button.click();
  }