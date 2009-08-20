application test

section bla
  
  define page root(){
    var list : List<Int> := genList()
    var list2 : List<Int> := genList2()
    
    for(i:Int in list){
      output(i)
    }
    break
    for(i:Int in list2){
      output(i)
    }
    break
 
  }
  
  function genList():List<Int>{
    var list : List<Int> := List<Int>();
    for(bla : Int from 0 to 4){
      list.add(bla);
    }
    return list;
  }
  
  function genList2():List<Int>{
    var list : List<Int> := List<Int>();
    for(i : Int from [3,6,43,67,3].get(0) to 4+4){
      list.add(i);
    }
    return list;
  }
