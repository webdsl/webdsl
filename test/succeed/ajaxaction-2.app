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
    "placeholder 1"
  }
  action("do",do2())
  action do2 () {
    replace (target, templ(s));
  }
  
  break
  placeholder pl {
    "placeholder 2"
  }
  test(s)

  break
  placeholder pl3 {
    "placeholder 3"
  }
  testset(sset)
  
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
    newt.save(); newt2.save();
  }
}

define page apage(s: String) {
  output(s)
}

define templ(s: List<Test>) {
  for(t:Test in s){
    output(t.bla)
  }
}

define test(s: List<Test>) {
  action("do",do2())
  action do2 () {
    replace (pl, test(s));
  }
}

define testset(s: Set<Test>) {
  action("do",do2())
  action do2 () {
    replace (pl3, testset(s));
  }
}
