//#8 Name 'in' is not allowed

application test

define page root() {
  var in := "ghhfg"
  
  action fsdfsdf(in:String){
    
  }
}
define page a(){  
  var in :String := "ghhfg"
}
define page b(){  
  var in :String
}
define page c(in : String){}
function c(in : String){}
function d(in : String):Bool{return true;}
predicate e(in : String){true}
