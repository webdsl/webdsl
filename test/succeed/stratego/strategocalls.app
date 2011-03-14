application com.example.strategocalls

function testSDF() : Text {
  var input := "application parseme";
  
  // Parse input
  var parsed : ATerm := SDF.get("WebDSL").parse(input);

  var appName : String := parsed.get(0).stringValue();
  
  return appName;
}

function testSTR() : Text {
  // Set-up
  var input := "application parseme imports foo";
  var parsed : ATerm :=  SDF.get("WebDSL").parse(input);
  
  var importReader : Stratego := Stratego.get("read-imports");
  var importName : ATerm := importReader.invoke("read-import", parsed);
  
  return importName.stringValue();
}

define page root() {

  var sdf : String := testSDF();
  var str : String := testSTR();

  "stratego calls testing"    
  "sdf test appname: "     
  output(sdf)
  "-"
  "str test module name: "
  output(str)
}

entity exampleEntity {
  property :: Text
}

test bla {
  var sdf : Text := testSDF();
  var str : Text := testSTR();

  assert(sdf == "parseme");
  assert(str == "foo");
}
