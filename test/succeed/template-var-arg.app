application test

page root(){
  testtemplate
}

entity Tmp{
  name : String
  i : Int
}

init{
  Tmp{ name := "tmp1name" i := 111 }.save();
  Tmp{ name := "tmp2name" i := 222 }.save();
}

template testtemplate(){
  var tmps := [Tmp{},Tmp{},Tmp{}]
  var tmpi := 3
  tabs(
    "Events",
    [
      ( "first",
        "second",
        987
      ),
      for(tmp:Tmp){
        (tmp.name, tmp.name, tmp.i),
        ("forall1","forall2",33)
      },
      ( "if",
        "else",
        654
      ),
      for(r:Tmp in [Tmp{},Tmp{},Tmp{}]){
        (r.name, r.name, r.i),
        ("forexp1","forexp2",3)
      },
      for(r:Tmp in tmps){
        (r.name, r.name, r.i),
        ("forvar1","forvar2",6)
      },
      for(t: Int from 0 to tmpi){
        (t.toString(), ""+t, t),
        ("forcount1","forcount2",15)
      }
    ]
  )
}

template tabs(title: String, contents : [t: String, text: String, i: Int]) {
  output(title)
  for(c in contents){
    output(c.t)
    output(c.text)
    output(c.i)
  }
}

test{
  log(rendertemplate(testtemplate()));
  assert(rendertemplate(testtemplate()) == "Eventsfirstsecond987tmp1nametmp1name111forall1forall233tmp2nametmp2name222forall1forall233ifelse6540forexp1forexp230forexp1forexp230forexp1forexp230forvar1forvar260forvar1forvar260forvar1forvar26000forcount1forcount215111forcount1forcount215222forcount1forcount215");
  log(rendertemplate(testtypeof()));
  assert(rendertemplate(testtypeof()) == "Eventstmp1nametmp1name111forall1forall233tmp2nametmp2name222forall1forall233Events0forexp1forexp230forexp1forexp230forexp1forexp23Events0forvar1forvar260forvar1forvar260forvar1forvar26Events000forcount1forcount215111forcount1forcount215222forcount1forcount215");
}

template testtypeof(){
  var tmps := [Tmp{},Tmp{},Tmp{}]
  var tmpi := 3
  tabs(
    "Events",
    [
      for(tmp:Tmp){
        (tmp.name, tmp.name, tmp.i),
        ("forall1","forall2",33)
      }
    ]
  ) 
  tabs(
    "Events",
    [
      for(r:Tmp in [Tmp{},Tmp{},Tmp{}]){
        (r.name, r.name, r.i),
        ("forexp1","forexp2",3)
      }
    ]
  )
  tabs(
    "Events",
    [  
      for(r:Tmp in tmps){
        (r.name, r.name, r.i),
        ("forvar1","forvar2",6)
      }
    ]
  )
  tabs(
    "Events",
    [
      for(t: Int from 0 to tmpi){
        (t.toString(), ""+t, t),
        ("forcount1","forcount2",15)
      }
    ]
  )
}
