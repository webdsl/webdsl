application customroutingtest

entity Project{
  name : String 
}

var p1 := Project{ name := "WebDSL" }
var p2 := Project{ name := "Routing" }

page root(){
  for(p:Project order by p.name){
    navigate project(p) { output(p.name) }
  }
  output(baseUrl())
}
  
page project(p:Project){
  "Project: "
  output(p.name)
}
  
routing {
  receive(urlargs:[String]) {
    log(baseUrl());
    //var args := urlComponents();
    if(urlargs.length == 2){
      return [urlargs[1], urlargs[0]];
    }
    else{
      return null; // will use default
    }
  }
  construct (appurl:String,pagename:String, pageargs:[String]) { // construct is not necessarily the same as receive, e.g. when using the domain name to specify one of the arguments in a multitenant application
    if(pageargs.length == 1){
      return [appurl,pageargs[0], pagename];
    }
    else{
      return null;
    }
  }
}

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
  assert(elist.length == 2, "expected number of <a> elements did not match");
  assert(elist[0].getAttribute("href").endsWith("project"));
  elist[0].click();  
  assert(d.getPageSource().contains("Project: Routing"));
}
  