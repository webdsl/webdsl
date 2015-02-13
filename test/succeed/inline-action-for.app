application test

entity Test {
  i::Int
}
var globaltest := Test { i := 445 }

define page root() {
  output(globaltest.i)
  var i := globaltest
  form{
    action("+10",
      action { 
        log(""+i.i);
        log(""+globaltest.i);
        for(t:Test){ 
          for(i1:Int from 0 to 10){ 
            t.i := t.i+1; 
          }
        } 
      }
    )
  } 
}
