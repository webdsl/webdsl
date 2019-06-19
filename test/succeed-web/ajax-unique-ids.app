application test

  entity Tmp {
    s : String
  }

  var t1 := Tmp{ s:= "t1" }
  var t2 := Tmp{ s:= "t2" }

  page root(){
    
    submitlink action{ replace(ph1, showUniqueId(t1)); }[class="link"]{ "link1" }
    submitlink action{ replace(ph2, showUniqueId(t2)); }[class="link"]{ "link2" }
    
    placeholder ph1{}
    placeholder ph2{}
  }
  
  ajax template showUniqueId( t : Tmp ){
    var tplid := id
    
    span[id=t.s]{
      output( tplid )
    }
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    for( elem in d.findElements(SelectBy.className("link")) ){
      elem.click();
      sleep(2000);
    }
    var id1 := d.findElement( SelectBy.id("t1") ).getText();
    var id2 := d.findElement( SelectBy.id("t2") ).getText();
    assert( id1 != id2, "Call to 'id' should be different for ajax loaded templates that have different arguments" );
  }
