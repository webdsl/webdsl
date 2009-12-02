//Can only assign to fields or vars (except global or session vars).
application test

define page root() {
}

entity Test{
  test :: String
  function test():String{
    return "fsdg";
  }
}

function test(){
  var s := Test{test := "rwefd"};
  s.test() := null;
   
}