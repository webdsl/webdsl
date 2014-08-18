application test

section pages

entity Test {
  bla :: String
}

entity TestEnt {
  one :: String
}

var t_1 := Test { bla := "1" }
var t_2 := Test { bla := "2" }
var t_3 := Test { bla := "3" }
var t_4 := Test { bla := "4" }
var t_5 := Test { bla := "5" }

define page root() {
  var s: List<Test> := [t_1,t_2,t_3,t_4,t_5]
  var sset: Set<Test> := {t_1,t_2,t_3,t_4,t_5}
  templ(s)
  placeholder target {
    "placeholder: 'target'"
  }
  form{ container[onclick:=do2()]{ "do"} }
  form{ submit("doit",do2())[ajax] }
  action do2 () {
    log("replacing: 'target'");
    for(i:Int from 0 to 10000000) { var a := i; } //just take some time
    replace (target, templ(s));
  }
  
  break
  placeholder pl {
    "placeholder: 'pl'"
  }
  test(s, pl)

  break
  placeholder pl3 {
    "placeholder: 'pl3'"
  }
  testset(sset, pl3)
  
  break
  for(t:TestEnt){
    output(t.one)
  }
  var newt := TestEnt{ one := "the text" }
  var newt2 := TestEnt{ one := "another text" }
  form {
    input(newt.one)
    input(newt2.one)
    action("save1",action{ newt.save(); })
    action("save2",action{ newt2.save(); })
    for(forone : Int from 0 to 1){
      action("save both",saveboth())
      for(fortwo : Int from 0 to 1){
        action("save both",saveboth())
        for(forthree : Int from 0 to 1){
          action("save both",saveboth())
        }
      }
    }
  }
  action saveboth(){
    newt.save();
    newt2.save();
  }
  //large number of buttons to verify load image and no double submits
  var newt3 := TestEnt{ one := "another text" }
  form {
    input(newt3.one)
    for(forone : Int from 0 to 500){
      container[onclick:=saveit()]{"save"}
    }
  }
  
  action saveit(){
    newt3.save();
  }
}

define page apage(s: String) {
  output(s)
}

define ajax templ(s: List<Test>) {
  for(t:Test in s){
    output(t.bla)
  }
}

define ajax test(s: List<Test>, pl: Placeholder) {
  form { submit("do",do2())[ajax]}
  action do2 () {
    log("replacing: 'pl'");
    replace (pl, test(s, pl));
  }
}

define ajax testset(s: Set<Test>, pl3test: Placeholder) {
  form { submit("do",do2())[ajax] }
  action do2 () {
    log("replacing: 'pl3'");
    replace (pl3test, testset(s, pl3test));
  }
}
