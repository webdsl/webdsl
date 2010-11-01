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
  
  navigate test2(){"test page"}
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

entity User {
  name :: String
  person1 -> Person
  person2 -> Person
  validate(person1 == null || person1 != person2, "cannot choose same person")
}

var u1 := User{ name := "u1" }
var u2 := User{ name := "u2" }

define page test2(){
  form{
    for(u:User){
      radio(u.person1,from Person)[style="margin-left:20px;"]
      radio(u.person2,from Person)[style="margin-left:20px;"]
    } separated-by{<br />}
    submit action{} {"save"}
  }
}
