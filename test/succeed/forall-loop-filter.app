application test

section bla
  
  entity Entity{
    name :: String
  }
  
  init{
    var e1 := Entity { name := "e1" };
    e1.save();
    var e2 := Entity { name := "e2" };
    e2.save();
    var e3 := Entity { name := "e3" };
    e3.save();
    var e4 := Entity { name := "e4" };
    e4.save();
    var e5 := Entity { name := "e5" };
    e5.save();
    var e6 := Entity { name := "e6" };
    e6.save();
    var e7 := Entity { name := "e7" };
    e7.save();
  }
  
  define page home(){
    var entList : List<Entity> := genEntList()
    var entList2 : List<Entity> := genEntList2()
    
    for(e:Entity in entList){
      output(e.name)
    }
    " == "
    for(e:Entity where e.name != "e4" order by e.name desc limit 2 offset 1){
      output(e.name)
    }
    break
    for(e:Entity in entList2){
      output(e.name)
    }
    
  }
  
  function genEntList():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity where e.name != "e4" order by e.name desc limit 2 offset 1){
      list.add(e);
    }  
    return list;
  }
  function genEntList2():List<Entity>{
    var list : List<Entity> := List<Entity>();
    // test order by with arbitrary exp
    for(e:Entity where e.name != "e4" order by e.name asc limit 2 offset 1){
      list.add(e);
    }  
    return list;
  }