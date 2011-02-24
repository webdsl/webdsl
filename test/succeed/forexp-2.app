
application test

  define page root() {
  }
  test listcomprehension{
    var i := {i_1, Item{name:="2"}, Item{name:="3"}};
    var iset := ItemSet{ items := i };
    var v1 := TestEnt{ itemSet := iset };
    assert(v1.itemSet.items.length==3);
    assert(test(v1).itemSet.items.length==2);
    assert(v1.show1().length==2);
    assert(v1.show2().length==2);
    
    var v := TestEnt{ itemList := ItemList{ items := [i_1, Item{name:="2"}, Item{name:="3"}] } };
    v.itemList.items := [x | x : Item in v.itemList.items where x != i_1];
    log(""+v.itemList.items);
    assert(v.itemList.items.length == 2);
  }
  entity TestEnt{
    itemSet -> ItemSet
    itemList -> ItemList
    
    function show1():Set<Item>{
      return [x | x : Item in this.itemSet.items where x != i_1].set();
    }
    function show2():Set<Item>{
      return [x | x : Item in itemSet.items where x != i_1].set();
    }
  }
  
  entity ItemSet {
    items -> Set<Item>
  }
  entity ItemList {
    items -> List<Item>
  }
  
  entity Item {
    name :: String
  }
  
  var i_1 := Item{ name := "i_1" }

  function test(i:TestEnt): TestEnt{
    var it := i_1; 
    i.itemSet.items := [x | x : Item in i.itemSet.items where x != it].set();
    return i;
  }
  