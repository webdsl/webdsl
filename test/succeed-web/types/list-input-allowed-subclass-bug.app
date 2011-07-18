//authors property was not found in ReflectionEntity when trying to get allowed list options 

application exampleapp

entity PublishedVolume:Publication{
  
}

entity Publication {
   authors -> List<Author>
   authors1 <> List<Author>
}

entity Author {
   name :: String
}

var a1 := Author{name:="a1"}
var a2 := Author{name:="a2"}
var a3 := Author{name:="a3"}

var p1 := PublishedVolume{}

define page root() {
   var p := p1
   form{
      <p> "Authors" </p>
      <p> input(p.authors) </p> 
      <p> input(p.authors1) </p> 
      submit submitPub() { "Submit" }
   }

   action submitPub() {
      p.save();
      return root();
   }
}


test listtemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  
  assert(d.findElements(SelectBy.tagName("option")).length == 6);
  
  var addbuttons := d.findElements(SelectBy.cssSelector("input[type='button']"));
  addbuttons[0].click();
  addbuttons[1].click();
  assert(d.findElements(SelectBy.tagName("li")).length == 2);
  
  var savebutton := d.findElement(SelectBy.className("button"));
  savebutton.click();
  
  assert(d.findElements(SelectBy.tagName("option")).length == 6);
  assert(d.findElements(SelectBy.tagName("li")).length == 2);
  
  d.close();
}