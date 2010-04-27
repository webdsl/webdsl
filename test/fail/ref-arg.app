//ref-arg.app:15/17
//ref-arg.app:15/45
//ref-arg.app:15/4
//ref-arg.app:18/15
//ref-arg.app:18/43
//ref-arg.app:21/12
//ref-arg.app:23/18
//ref-arg.app:24/14
//ref-arg.app:29/10
//ref-arg.app:31/21
//ref-arg.app:33/24
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


