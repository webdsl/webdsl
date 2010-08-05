application test

// standard

entity NoName {
}

entity WithAnno {
  title :: String(name)
}

entity WithName {
  name :: String
}

// extend

entity ExtendedWithAnno {
}
extend entity ExtendedWithAnno {
  title :: String(name)
}

entity ExtendedWithName {
}
extend entity ExtendedWithName {
  name :: String
}

// subclass of NoName

entity NoName_NoName : NoName {
}

entity NoName_Anno : NoName {
  title1 :: String(name)
}

entity NoName_Name : NoName {
  name1 :: String(name)
}

// subclass of WithAnno

entity WithAnno_NoName : WithAnno {
}

entity WithAnno_Anno : WithAnno {
  title1 :: String(name)
}

entity WithAnno_Name : WithAnno {
  name1 :: String(name)
}

// subclass of WithName

entity WithName_NoName : WithName {
}

entity WithName_Anno : WithName {
  title1 :: String(name)
}

entity WithName_Name : WithName {
  name1 :: String(name)
}

  
define page root(){

  var nn : NoName := NoName{};
  output("1:") output(nn.name)
  var wa : WithAnno := WithAnno{title := "thename"}
  output("2:") output(wa.name)
  var wn : WithName := WithName{name := "thename"}
  output("3:") output(wn.name)
  
  var ewa : ExtendedWithAnno := ExtendedWithAnno{title := "thename"}
  output("e1:") output(ewa.name)
  var ewn : ExtendedWithName := ExtendedWithName{name := "thename"}
  output("e2:") output(ewn.name)
  
  var subxx : NoName_NoName := NoName_NoName{}
  output("subxx:") output(subxx.name)
  var subxa : NoName_Anno := NoName_Anno{title1 := "thename"}
  output("subxa:") output(subxa.name)
  var subxn : NoName_Name := NoName_Name{name1 := "thename"}
  output("subxn:") output(subxn.name)
  
  var subax : WithAnno_NoName := WithAnno_NoName{title := "supername"}
  output("subax:") output(subax.name)
  var subaa : WithAnno_Anno := WithAnno_Anno{title := "supername", title1 := "thename"}
  output("subaa:") output(subaa.name)
  var suban : WithAnno_Name := WithAnno_Name{title := "supername", name1 := "thename"}
  output("suban:") output(suban.name)
  
  var subnx : WithName_NoName := WithName_NoName{name := "supername"}
  output("subnx:") output(subnx.name)
  var subna : WithName_Anno := WithName_Anno{name := "supername", title1 := "thename"}
  output("subna:") output(subna.name)
  var subnn : WithName_Name := WithName_Name{name := "supername", name1 := "thename"}
  output("subnn:") output(subnn.name)
  
}
  

// test

  test one {
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("1:"), "NoName");						//uuid
    assert(d.getPageSource().contains("2:thename"), "WithAnno");
    assert(d.getPageSource().contains("3:thename"), "WithName");
    
    assert(d.getPageSource().contains("e1:thename"), "ExtendedWithAnno");
    assert(d.getPageSource().contains("e2:thename"), "ExtendedWithName");
    
    assert(d.getPageSource().contains("subxx:"), "NoName_NoName");	//uuid
    assert(d.getPageSource().contains("subxa:thename"), "NoName_Anno");
    assert(d.getPageSource().contains("subxn:thename"), "NoName_Name");
    
    assert(d.getPageSource().contains("subax:supername"), "WithAnno_NoName");
    assert(d.getPageSource().contains("subaa:thename"), "WithAnno_NoName");
    assert(d.getPageSource().contains("suban:thename"), "WithAnno_Name");
    
    assert(d.getPageSource().contains("subnx:supername"), "WithName_NoName");
    assert(d.getPageSource().contains("subna:thename"), "WithName_Anno");
    assert(d.getPageSource().contains("subnn:thename"), "WithName_Name");
    d.close();
  }
