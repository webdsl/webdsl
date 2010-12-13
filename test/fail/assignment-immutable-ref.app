//#15 Assignment to this variable is not allowed.
//#5 This variable is not allowed in 'input'
//#1 Derived property is not allowed in 'input'
//#1 Global variable b1 is not allowed in inputs

application test

  entity Bar {
    string :: String
    int :: Int
        
    function test(a:Int, b:Bar){
      this := null;
      a := 7;
      b := null;
      for(i:Int from 0 to 9){
        i := 4;
      }
      for(bar:Bar){
        bar := null;
      }
      for(bar:Bar in  from Bar){
        bar := null;
      }
    }
  }
  
  var b1 := Bar{}

  define page root(){
  }
  
  define test(a:Int, b:Bar){
    form{
      input(b1) //already had a more specific check for globals
      input(b1.name) //@TODO should also be reported
      input(b)
      input(a)
      for(i:Int from 0 to 9){
        input(i)
      }
      for(bar:Bar){
        input(bar)
      }
      for(bar:Bar in  from Bar){
        input(bar)
      }
    }
    action save(c:Bar,d:Int){
      a := 4;
      b := Bar{};
      c := null;
      d := 0;
    }
  }
  
  function test(a:Int, b:Bar){
    a := 7;
    b := null;
    for(i:Int from 0 to 9){
      i := 4;
    }
    for(bar:Bar){
      bar := null;
    }
    for(bar:Bar in  from Bar){
      bar := null;
    }
  }
  
  