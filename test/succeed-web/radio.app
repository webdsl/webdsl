application exampleapp

define page root() {
  form{
    for(p:Person){
      radio(p.relation,from Person)[style="margin-left:20px;"]
      radio(p.relbla,from Bla)[style="height:20px;widht:20px;"]
    } separated-by{<br />}
    submit action{} {"save"}
  }
  <br />
  for(p:Person){
    output(p.relation)
    output(p.relbla)
  }separated-by{<br />}
}

entity Person {
  name    :: String
  relation -> Person
  relbla -> Bla
}

entity Bla {
  name :: String
}

var b1 := Bla{ name := "b1" }
var b2 := Bla{ name := "b2" }

var p1 := Person{ name := "1" }
var p2 := Person{ name := "2" }
var p3 := Person{ name := "3" }
var p4 := Person{ name := "4" }

define ignore-access-control radio1(e1:Ref<Entity>,e2:List<Entity>){
  var rname := getUniqueTemplateId()
  for(p:Entity in e2 order by p.name){
    if(e1==p){
      <input type="radio" checked="checked" name=rname value=p.id all attributes/>
    }
    else{
      <input type="radio" name=rname value=p.id all attributes/>
    }
    output(p.name)
  }
  databind{
    var tmp : String:= getRequestParameter(rname);
    if(tmp != null){
      var p := loadEntity(e1.getTypeString(),UUIDFromString(tmp));
      if(p in e2){
        e1 := p;
      }
    }
  }
}
