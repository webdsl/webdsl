application test

  define page root(){    
  }
  
  function foo(i:Int,b:Bool):String{
    return ""+i+b;
  }
  
  function bar(f:function(Int,Bool):String):String{
    return f(5,true);
  }
  
  function bar(s:String):String{ return "ab"+s; }
  function bar(int:Int,bool:Bool):String{ return int+"qwe"+bool; }
  /*function bar(i:Int){ }
  function bar(s:String){ }
  function bar(n:RequestLogEntry):Bool{ return false;}*/
  function bar(b:Bool,s:String,i:Int):Long{ return 1L; }
  function iamnotoverloaded(s:String):String{ return "ab"+s; }
  test functionexp{
    //function.foo()
    var a:="abc";
    assert( bar(function(b:Int,c:Bool):String{ return a+b+c; }) == "abc5true"); //inline function passed as argument
    assert( function.iamnotoverloaded(String):String("cd") == "abcd"); //reference to not-overloaded global function with call
    assert( function.bar(String):String("cd") == "abcd"); //reference to overloaded global function with call
    assert( bar(function.bar(Int,Bool):String) == "5qwetrue"); //reference to global function passed as argument
    var thefun := function.bar(Int,Bool):String(*,false); //partial function application
    assert( thefun(5) == "5qwefalse");
    // @TODO assert( (function(b:Int,c:Bool):String{ return "2"+b+c; })(*,true)(5) == "25true"); //partial function application of inline function
  }
  
  