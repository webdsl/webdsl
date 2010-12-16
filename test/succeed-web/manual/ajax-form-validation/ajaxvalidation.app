application exampleapp

var pAlice := Person{username := "Alice"};
init {
  var p := Person{username := "Bob"};
  p.save();
  var p := Person{username := "Charlie"};
  p.save();
}

entity Person {
  fullname :: String
  username    :: String (name)
  parents     -> Set<Person>
  children    -> Set<Person>
}

imports templates/templates

define page root() {
  main()
  define body() {
    personedit(Person{})
  }
}

define page edit(){
  main()
  define body() {
    personedit(pAlice)
  }
}

define errorclass(){
  <div class="errorclass"> elements() </div>
}
define ajax empty(){ "" }
define ajax mpusername(name: String){ errorclass{ "Username " output(name) " has been taken already" } }
define ajax mpusernameempty(){ errorclass{ "Username may not be empty" } }
define ajax mpfullname(){ errorclass{ "Username and fullname should not be the same" } }
define ajax mpfullnameempty(){ errorclass{ "Fullname may not be empty" } }
define ajax mpparents(pname:String,names : List<String>){ 
  errorclass{ 
    "Person" 
    if(names.length > 1){"s"}
    " " 
    for(name: String in names){
      output(name)
    } separated-by {", "}
    " cannot be both parent and child of " output(pname)
  }
}

function checkUsernameEmpty(p:Person):Bool{
  if(p.username != ""){ 
    replace(pusernameempty, empty());
    return true;
  } 
  else {
    replace(pusernameempty, mpusernameempty());
    return false; 
  }
}
function checkUsername(p:Person, realp:Person):Bool{
  var matches := from Person as p1 where p1.username = ~p.username;
  if(matches.length == 0 || (matches.length == 1 && matches[0] == realp)){ 
    replace(pusername, empty());
    return true;
  } 
  else {
    replace(pusername, mpusername(p.username));
    return false; 
  }
}

function checkFullnameEmpty(p:Person):Bool{
  if(p.fullname != ""){ 
    replace(pfullnameempty, empty());
    return true;
  } 
  else {
    replace(pfullnameempty, mpfullnameempty());
    return false; 
  }
}
function checkFullname(p:Person) :Bool{
  if(p.username != p.fullname) { 
    replace(pfullname, empty());
    return true;
  } 
  else{
    replace(pfullname, mpfullname());
    return false; 
  }
}

function checkParents(p:Person) : Bool{
  var conflicts := List<String>();
  for(person:Person in p.parents where person in p.children){
    conflicts.add(person.username);
  }
  if(conflicts.length > 0) { 
    replace(pparents, mpparents(p.name,conflicts));
    return false; 
  }
  else{
    replace(pparents, empty());
    return true; 
  }
}

define personedit(realp:Person){
  var p := Person{ username := realp.username fullname := realp.fullname children := realp.children parents := realp.parents};
  form{
    par{
      label("username: "){ input(p.username)[onkeyup := action{ checkUsername(p,realp); checkUsernameEmpty(p); checkFullname(p); }] }
      placeholder pusernameempty { }
      placeholder pusername { }
    }
    par{
      label("fullname: "){ input(p.fullname)[onkeyup := action{ checkFullname(p); checkFullnameEmpty(p); } ] }
      placeholder pfullnameempty { }
      placeholder pfullname { }
    }
    par{
      label("parents: "){ input(p.parents)[onchange := action{ checkParents(p); } ] }
      placeholder pparents { }
    }
    par{
      label("children: "){ input(p.children)[onchange := action{ checkParents(p); } ] }
    }
    submit save() [ajax] {"save"} //explicit ajax modifier currently necessary in non-ajax templates to enable replace
  }	
  action save(){ 
    // made an issue requesting & operator :)
    var checked := checkUsernameEmpty(p);
    checked := checkUsername(p,realp) && checked;
    checked := checkFullname(p) && checked;
    checked := checkParents(p) && checked;
    checked :=  checkFullnameEmpty(p) && checked;
    if(checked){
      realp.username := p.username;
      realp.fullname := p.fullname;
      realp.parents := p.parents;
      realp.children := p.children;
      realp.save(); // does nothing in the case of an update
      return root();
    } 
  }
}



test one {
  
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 6, "expected 6 <input> elements");
    /*
    elist[1].sendKeys("TestPerson");
    elist[2].sendKeys("TestPerson");
    log(d.getPageSource());
    assert(d.getPageSource().contains("should not be the same"), "error not shown");
    */
    /*elist[5].click();
    
    assert(d.getPageSource().contains("TestPerson"), "TestPerson was not saved}");
    */
    d.close();
  
}
