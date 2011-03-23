//#3 only allowed in formal parameters 
//Global variable s has illegal type
//#4 No such type Ref<String>

application test
entity Bla{
  
  function a(a:Ref<Int>):Ref<Int>{ var s : Ref<String>; return a; }
}

function a(a:Ref<Int>):Ref<Int>{ var s : Ref<String>; return a; }

define page root(){
  var s : Ref<String>
  
  action test(a:Ref<Int>){
    var s : Ref<String>;
  }
  
}

var s : Ref<Bla> := Bla {}

define ajax Test(b:Ref<Bool>){}

define page fsdfdgf(a:Ref<Bla>){}


