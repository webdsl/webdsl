application test

native class java.util.UUID as UUID {
	static fromString(String) : UUID
}

entity Root {
  name :: String
  noProxyA -> NoProxyA
  noProxyB -> NoProxyB
}

entity NoProxyA {
  name :: String
  root -> Root (inverse = Root.noProxyA)
}

entity NoProxyB {
  name :: String
  root -> Root (inverse = Root.noProxyB)
}

init{
  Root{name := "Root1" noProxyA := NoProxyA{name:= "NoProxyA1"} noProxyB := NoProxyB{name:= "NoProxyB1"}}.save();
  Root{name := "Root2" noProxyA := NoProxyA{name:= "NoProxyA2"} noProxyB := NoProxyB{name:= "NoProxyB2"}}.save();
  Root{name := "Root3" noProxyA := NoProxyA{name:= "NoProxyA3"} noProxyB := NoProxyB{name:= "NoProxyB3"}}.save();
}

define page root() {
  <div id="r1">output("" + (from Root as r order by r.name asc)[0].id)</div>
}

define page none() {
  for(r : Root) {
    output(r)
  } separated-by { <br /> }
}

define page onlyone() {
  for(r : Root) {
    output(r) "_" output(r.noProxyA)
  } separated-by { <br /> }
}

define page both() {
  for(r : Root) {
    output(r) "_" output(r.noProxyA) <br />
    output(r) "_" output(r.noProxyB)
  } separated-by { <br /> }
}

define page newNoProxyA(r : Root) {
  form {
    action("save",save())[class="newNoProxyA_savebutton"]
  }
  action save(){
    r.noProxyA.name := "OldNoProxyA1";
    r.noProxyA := NoProxyA { name := "NewNoProxyA1" };
    r.save();
    return allNoProxyA();
  }
}

define page touchRoot(r : Root) {
  output(r) "_" output(r.noProxyA)
  form {
    action("save",save())[class="touchRoot_savebutton"]
  }
  action save(){
    r.name := "Root1T";
    r.save();
    return allNoProxyA();
  }
}

define page allNoProxyA() {
  for(l : NoProxyA) {
    if(l.root == null) {
      "Null_"
    }
    else {
      output(l.root) "_"
    }
    output(l)
  }
}

test {
  var d : WebDriver := getFirefoxDriver();

  d.get(navigate(root()));
  var elem : WebElement := d.findElement(SelectBy.id("r1"));
  var r1 : Root := Root {};
  r1.id := UUID.fromString(elem.getText());

  // We check that the root object can be loaded without fetching the no-proxy properties
  d.get(navigate(none()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 3);
  elem := d.findElement(SelectBy.id("sqllogentities"));
  assert(elem.getText().parseInt() == 4); // 1 SessionManager, 3 Root
  elem := d.findElement(SelectBy.id("sqllogcollections"));
  assert(elem.getText().parseInt() == 1); // 1 SessionManager._messages

  // We check that the root object can be loaded with some, but not all no-proxy properties
  d.get(navigate(onlyone()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 3);
  elem := d.findElement(SelectBy.id("sqllogentities"));
  assert(elem.getText().parseInt() == 7); // 1 SessionManager, 3 Root, 3 NoProxyA
  elem := d.findElement(SelectBy.id("sqllogcollections"));
  assert(elem.getText().parseInt() == 1); // 1 SessionManager._messages

  // We check that the root object can be loaded with all no-proxy properties
  d.get(navigate(both()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 3);
  elem := d.findElement(SelectBy.id("sqllogentities"));
  assert(elem.getText().parseInt() == 10); // 1 SessionManager, 3 Root, 3 NoProxyA, 3 NoProxyB
  elem := d.findElement(SelectBy.id("sqllogcollections"));
  assert(elem.getText().parseInt() == 1); // 1 SessionManager._messages

  // We check that no-proxy properties get updated
  d.get(navigate(newNoProxyA(r1)));
  var elist : List<WebElement> := d.findElements(SelectBy.className("newNoProxyA_savebutton"));
  assert(elist.length == 1);
  elist[0].click();
  assert(d.getPageSource().contains("Root1_NewNoProxyA1"), "NewNoProxyA1 not found");
  assert(d.getPageSource().contains("Null_OldNoProxyA1"), "OldNoProxyA1 not found");
  d.get(navigate(both()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 3);
  elem := d.findElement(SelectBy.id("sqllogentities"));
  assert(elem.getText().parseInt() == 10); // 1 SessionManager, 3 Root, 3 NoProxyA, 3 NoProxyB
  elem := d.findElement(SelectBy.id("sqllogcollections"));
  assert(elem.getText().parseInt() == 1); // 1 SessionManager._messages
  assert(d.getPageSource().contains("Root1_NewNoProxyA1"), "NewNoProxyA1 not found");

  // We check that everything keeps working if we save the root object without changing the no-proxy properties
  // In this test only one no-proxy property is fetched
  d.get(navigate(touchRoot(r1)));
  assert(d.getPageSource().contains("Root1_NewNoProxyA1"), "Wrong state at start of touch test");
  var elist : List<WebElement> := d.findElements(SelectBy.className("touchRoot_savebutton"));
  assert(elist.length == 1);
  elist[0].click();
  assert(d.getPageSource().contains("Root1T_NewNoProxyA1"), "NewNoProxyA1 not found");
  d.get(navigate(both()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 3);
  elem := d.findElement(SelectBy.id("sqllogentities"));
  assert(elem.getText().parseInt() == 10); // 1 SessionManager, 3 Root, 3 NoProxyA, 3 NoProxyB
  elem := d.findElement(SelectBy.id("sqllogcollections"));
  assert(elem.getText().parseInt() == 1); // 1 SessionManager._messages
  assert(d.getPageSource().contains("Root1T_NewNoProxyA1"), "NewNoProxyA1 not found");
}

