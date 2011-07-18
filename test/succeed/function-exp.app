application test

  define page root(){    
  }
  
  function foo(i:Int,b:Bool):String{
    return ""+i+b;
  }
  
  function bar(f:function(Int,Bool):String):String{
    return f(5,true);
  }
  
  function bar(){ }
  /*function bar(i:Int){ }
  function bar(s:String){ }
  function bar(n:RequestLogEntry):Bool{ return false;}*/
  function bar(b:Bool,s:String,i:Int):Long{ return 1L; }
  
  test functionexp{
    //function.foo()
    var a:="abc";
    assert( bar(function(b:Int,c:Bool):String{ return a+b+c; }) == "abc5true");
  //  function(b:Int,c:Bool):String{ return ""+b+c; }(*,true);
  }
  
  