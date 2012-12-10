application test

entity Person{
  name :: String (searchable)
}

page root(){
  selectPersonFromList()
  
  //overrides global template
  define personInContext( p : Person ){
    output(p)
  }  
}

define selectPersonFromList() {
  var lst := (search Person matching "name").results();
    
  var groups := toGroups( lst )
  for ( g : List<Person> in groups){
    outputPersonList(g)
  }
}

define outputPersonList( ps : List<Person> ) {
  for ( p: Person in ps){
      personInContext (p)
  }
}

define span personInContext( p : Person ){
  //to be overridden
}

function toGroups ( ps : List<Person>) : List<List<Person>> {
  var a := List<Person>();
  var b := List<List<Person>>();
  
  b.add(a);
  return b;
} 