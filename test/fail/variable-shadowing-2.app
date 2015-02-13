//#1 Variable name 'x' is already defined in this context
//#1 Variable name 'y' is already defined in this context
//#1 Variable name 'z' is already defined in this context

application test

page root() {
  action test1(){
    var x := 1;
    var x := 2;
  }
  action test2(){  
    var y:Int := 1;
    var y:Int := 2;
  }
  action test3(){  
    var z:Int;
    var z:Int;
  }
}
