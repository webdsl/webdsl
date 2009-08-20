application test

section bla
  
  entity Entity2{
    name :: String
  }
  
  init{
    var e1 := Entity2 { name := "e1" };
    e1.save();
    var e2 := Entity2 { name := "e2" };
    e2.save();
    var e3 := Entity2 { name := "e3" };
    e3.save();
    var e4 := Entity2 { name := "e4" };
    e4.save();
    var e5 := Entity2 { name := "e5" };
    e5.save();
    var e6 := Entity2 { name := "e6" };
    e6.save();
    var e7 := Entity2 { name := "e7" };
    e7.save();
  }
  
  define page root(){
    var entList : List<Entity2> := genEntList()
    var entList2 : List<Entity2> := genEntList2()
    
    for(e:Entity2 in entList){
      output(e.name)
    }
    " == "
    for(e:Entity2 where e.name != "e4" order by e.name desc limit 2 offset 1){
      output(e.name)
    }
    break
    for(e:Entity2 in entList2){
      output(e.name)
    }
    
  }
  
  function genEntList():List<Entity2>{
    var list : List<Entity2> := List<Entity2>();
    for(e:Entity2 where e.name != "e4" order by e.name desc limit 2 offset 1){
      list.add(e);
    }  
    return list;
  }
  function genEntList2():List<Entity2>{
    var list : List<Entity2> := List<Entity2>();
    // test order by with arbitrary exp
    for(e:Entity2 where e.name != "e4" order by e.name asc limit 2 offset 1){
      list.add(e);
    }  
    return list;
  }
