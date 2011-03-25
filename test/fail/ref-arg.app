//ref-arg.app:15/15
//ref-arg.app:15/37
//ref-arg.app:18/13
//ref-arg.app:18/35
//ref-arg.app:21/4
//ref-arg.app:23/16
//ref-arg.app:24/6
//ref-arg.app:29/2
//ref-arg.app:29/2
//ref-arg.app:29/2

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


