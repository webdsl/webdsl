//#1 Variable name 'x' is already defined in this context
//#1 Variable name 'y' is already defined in this context
//#1 Variable name 'z' is already defined in this context
//#1 For loop variable name 'dup1' is already defined in this context.
//#1 For loop variable name 'dup2' is already defined in this context.
//#1 For loop variable name 'dup3' is already defined in this context.
//#1 For loop variable name 'dup4' is already defined in this context.

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

template testtemplate(){
  var tmps := [Tmp{},Tmp{},Tmp{}]
  var dup1 := 3
  var dup2 := 3
  var dup3 := 3
  var dup4 := 3
  tabs(
    "Events",
    [
      for(dup1: Tmp){
        (dup1.name, dup1.name, dup1.i),
        ("forall1","forall2",33)
      },
      for(dup2:Tmp in [Tmp{},Tmp{},Tmp{}]){
        (dup2.name, dup2.name, dup2.i),
        ("forexp1","forexp2",3)
      },
      for(dup3:Tmp in tmps){
        (dup3.name, dup3.name, dup3.i),
        ("forvar1","forvar2",6)
      },
      for(dup4: Int from 0 to tmpi){
        (dup4.toString(), ""+dup4, dup4),
        ("forcount1","forcount2",15)
      }
    ]
  )
}

entity Tmp{
  name : String
  i : Int
}
