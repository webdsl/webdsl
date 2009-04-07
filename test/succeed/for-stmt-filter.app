application test

section bla
  
  entity Entity{
    name :: String
  }
  
  entity EntityList{
    list -> List<Entity> 
  }

  
  var e1 := Entity { name := "e1" };
  var e2 := Entity { name := "e2" };
  var e3 := Entity { name := "e3" };
  var e4 := Entity { name := "e4" };
  var e5 := Entity { name := "e5" };
  var e6 := Entity { name := "e6" };
  var e7 := Entity { name := "e7" };
  var thelist := EntityList{ list := [e1,e2,e3,e4,e5,e6,e7] };  
  
  
  define page home(){
    var entList : List<Entity> := genEntList()
    var entList2 : List<Entity> := genEntList2()
    var entList3 : List<Entity> := genEntList3()
    var entList4 : List<Entity> := genEntList4()
    var entList5 : List<Entity> := genEntList5()
    
    for(e:Entity in entList){
      output(e.name)
    }
    break
    for(e:Entity in entList2){
      output(e.name)
    }
    break
    "no limit "
    for(e:Entity in entList3){
      output(e.name)
    }    
    break
    "no order "
    for(e:Entity in entList4){
      output(e.name)
    }    
    break
    "no where "
    for(e:Entity in entList5){
      output(e.name)
    }    
    
    
    break
    "this page should show:"
    break
    "e6e5"
    break
    "e3e5e6e7"
    break
    "no limit e1e2e3e5e6e7"
    break
    "no order e1"
    break
    "no where e7" 
  }
  
  function genEntList():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity in thelist.list where e.name != "e4" order by e.name desc limit 2 offset 1){
      list.add(e);
    }  
    return list;
  }
  function genEntList2():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity in thelist.list where e.name != "e4" order by e.name asc limit 4 offset 2){
      list.add(e);
    }  
    return list;
  }
  //no limit
  function genEntList3():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity in thelist.list where e.name != "e4" order by e.name+e.name asc){
      list.add(e);
    }  
    return list;
  }
  //no order
  function genEntList4():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity in thelist.list where e.name != "e4" limit 1){
      list.add(e);
    }  
    return list;
  }
  //no where
  function genEntList5():List<Entity>{
    var list : List<Entity> := List<Entity>();
    for(e:Entity in thelist.list order by e.name+e.name asc offset 6){
      list.add(e);
    }  
    return list;
  }