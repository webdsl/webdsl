application attributes

section pages

define template attrtest() {
  output(attribute("kop", "1"))
  output(attribute("kop2", "2"))
  output(attribute("kop3", "3"))
}

define page root() {
  "expects:: hoitest3:"
  attrtest[kop:= "hoi", kop2 := test]
}