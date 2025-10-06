application test

  define page root(){
    output(st1.name)
    div[class="times"]{ output(st1.timesUpdated) }
  }
  entity State{
    name : String
    timesUpdated : Int (default = 0)
  }

  var st1 := State{ name := "uninitialized" }

  function appinit(){
      st1.name := "app init finished";
      st1.timesUpdated := st1.timesUpdated + 1;
  }

  function bgtask(){
      st1.name := "background task finished";
      st1.timesUpdated := st1.timesUpdated + 1; 
  }
  
    
  invoke appinit() on application start
  invoke bgtask() every 4 seconds
    
  test buttonclick {
    
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    //allow 1 sec for appinit() to finish on application start
    sleep(1000);
    d.get(navigate(root()));
    assert(d.getPageSource().contains("app init finished"), "s1 seems not updated by appinit()");
    assert(getTimesUpdated(d) == 1);
    sleep(6000);
    d.get(navigate(root()));
    assert(d.getPageSource().contains("background task finished"), "s1 seems not updated by bgtask()");
    assert(getTimesUpdated(d) == 2);
    
    sleep(4000);
    d.get(navigate(root()));
    assert(getTimesUpdated(d) == 3);
  }
  
  function getTimesUpdated(d : WebDriver) : Int {
    var timesElem := d.findElements(SelectBy.className("times"))[0];
    var timesUpdated := timesElem.getText().parseInt();
    return timesUpdated;
  }
