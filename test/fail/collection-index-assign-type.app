//is incompatible with type in collection
application test

define page root() {
}

function getList():List<String>{
  return ["fd3edf","eftrf","4rgf"];
}

function test(){
 
  getList()[0] := 34;
   
}