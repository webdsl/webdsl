application exampleapp

  entity Ent {
    name :: String
    set -> Set<Ent>
    //list -> List<Ent>
    validate(!(e1 in set), "cannot select e1 in set")
    //validate(!(this in list), "cannot select self in list")
  }
  
var e1 := Ent{ name := "e1" }
var e2 := Ent{ name := "e2" }
var e3 := Ent{ name := "e3" }
var e4 := Ent{ name := "e4" }
var e5 := Ent{ name := "e5" }

init{
  e1.set := {e2,e3};
  e4.set := {e2,e3};
}

define page root(){
    test(e1)
}

define test(e:Ent){ 

  form{
    input(e.set,from Ent)[class = "input-elem"] //defined in built-in.app
    submit action{}[class = "button-elem"]{"save"}
  }	
  
  output(e.set)

}

