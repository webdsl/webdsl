application test  

define page root() {
	""	
}

define page home(max : Int) {  
  var min := min(1, 2);
  var r := max(1, 2);  
}
   
function max(i : Int, j : Int) : Int {
  if(i > j) { return i; } else { return j; }
}

function min(i : Int, j : Int) : Int {
  if(i > j) { return j; } else { return i; }
}