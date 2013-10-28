application test

// derive viewRows and editRows, and derive CRUD pages potentially perform a lot of expansion.
// testing on an entity with many properties

	var t1 := TestEnt{ p1 := "testvalue1" p5 := "testvalue5" }

  page root(){
  	div{
  	  navigate testEnt(t1)[class="viewpage"]{"viewpage"}
  	}
  	div{
  	  navigate editTestEnt(t1)[class="editpage"]{"editpage"}
  	}
  	
  	derive viewRows from t1
  	form{
  	  derive editRows from t1
  	  submit action{} {"save"}
  	}
  }
  
  derive CRUD TestEnt
 
  test bigentityderives{
  	// some simple tests to see whether the property values show up
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().split("testvalue1").length==3);
    assert(d.getPageSource().split("testvalue5").length==3);

    d.findElement(SelectBy.className("viewpage")).click();
    assert(d.getPageSource().contains("testvalue1"));
    assert(d.getPageSource().contains("testvalue5"));

    d.get(navigate(root()));
    d.findElement(SelectBy.className("editpage")).click();
    assert(d.getPageSource().contains("testvalue1"));
    assert(d.getPageSource().contains("testvalue5"));
  }

  entity TestEnt {
    p1 : String
    p2 : String
    p3 : String
    p4 : String
    p5 : String
    p6 : String
    p7 : String
    p8 : String
    p9 : String
    p10 : String
    p11 : String
    p12 : String
    p13 : String
    p14 : String
    p15 : String
    p16 : String
    p17 : String
    p18 : String
    p19 : String
    p20 : String
    p21 : String
    p22 : String
    p23 : String
    p24 : String
    p25 : String
    p26 : String
    p27 : String
    p28 : String
    p29 : String
    p30 : String
    p31 : String
    p32 : String
    p33 : String
    p34 : String
    p35 : String
    p36 : String
    p37 : String
    p38 : String
    p39 : String
    p40 : String
    p41 : String
    p42 : String
    p43 : String
    p44 : String
    p45 : String
    p46 : String
    p47 : String
    p48 : String
    p49 : String
    p50 : String
  }
