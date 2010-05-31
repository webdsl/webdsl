application exampleapp

define page root() {
  //for(i:Int from 0 to 9){
  form{
    //input(p1.relation)
    radio(p1.relation,from Person)[style="margin-left:20px;"]
    submit action{} {"save"}
  }
  //}
  <br />
  output(p1.relation)
}

entity Person {
  name    :: String
  relation -> Person
}

var p1 := Person{ name := "1" }
var p2 := Person{ name := "2" }
var p3 := Person{ name := "3" }
var p4 := Person{ name := "4" }

define ignore-access-control radio(e1:Ref<Person>,e2:List<Person>){
  var rname := getUniqueTemplateId() //needs to be reconstructable upon submit
  for(p:Person in e2 order by p.name){
    if(e1==p){
      <input type="radio" checked="checked" name=rname value=p.id all attributes/>
    }
    else{
      <input type="radio" name=rname value=p.id all attributes/>
    }
    output(p.name)
  }
  
  databind{
    log(getUniqueTemplateId());
    var tmp := getRequestParameter(rname);
    if(tmp != null){
      log(tmp);
//      var p := loadPerson(UUIDFromString(tmp));
      var p := loadEntity("Person",UUIDFromString(tmp)) as Person;
      log(""+p);
      if(p in e2){
        e1 := p;
      }
    }
  }
}
