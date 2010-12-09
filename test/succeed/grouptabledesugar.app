application grouptabledesugar

section pages

define page root() {
  "ik ben de body2"
  var s: String := "hoi";
 
  label("ik ben een input") { input(s) }
  label("en ik ben oko een input") { input(s) }
  
  spacer
  
  table {
    "rij 1"
    "rij 2"
  }
  
  spacer
  table {
    container { "rij 1" "rij 1"}
    "rij 2"
  }
  
  spacer
  
  table {
    row { "rij 1" "rij1" }
    "rij 2"
    "rij 3"
  }
  spacer
  
  table {
    row {
      column { "col 1" "col 1" }
      "col2" column { "col 3" }
    }
  }
  
  spacer
  
  group("hoi") {
    "onder" "elkaar" 
  }
  
  spacer
  
  group("hoi2") {
    groupitem { "naast" "elkaar" }
    groupitem { "ook" "naast" "elkaar" }
  }
  
  spacer
  
  table {
    header { "1" "2"}
    row { "3" "4" }
  }
  
  spacer
  
  group("de labels test") {
    row { label("ik ben een input") { input(s) } }
    row { label("en ik ben oko een input") { input(s) } }  	
  }
  
  table{
    "row x"
    rowtemp()
  }
  
  table{
    label("row 1 col 1") { "row 1 col 2" }
    label("row 2 col 1") { "row 2 col 2" }
    label("row 3 col 1") { "row 3 col 2" }
  }
  
  group("test"){
    label("row 1 col 1") { "row 1 col 2" }
    labels()
  }
  
}

define rowtemp(){
  row{ "rowtemp1" }
  "rowtemp2"
  rowtempl()
}

define rowtempl(){
 "rowtempl1"
 row{ "rowtempl2" coltemp()} 
}

define coltemp(){
  "col2"
  column{ "col3" }

}

define labels(){
    label("row 2 col 1") { "row 2 col 2" }
    label("row 3 col 1") { "row 3 col 2" }
}
