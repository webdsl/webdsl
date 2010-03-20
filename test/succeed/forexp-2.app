
application test

  define page root() {
    var v := TestEnt{ itemSet := ItemSet{ items := {i_1, Item{name:="2"}, Item{name:="3"}} } }
    output(test(v))
    output(v.show1())
    output(v.show2())
  }

  entity TestEnt{
    itemSet -> ItemSet
    
    function show1():Set<Item>{
      return [x | x : Item in this.itemSet.items where x != i_1];
    }
    function show2():Set<Item>{
      return [x | x : Item in itemSet.items where x != i_1];
    }
  }
  
  entity ItemSet {
    items -> Set<Item>
  }
  
  entity Item {
    name :: String
  }
  
  var i_1 := Item{ name := "i_1" }

  function test(i:TestEnt): TestEnt{
    var it := i_1; 
    i.itemSet.items := [x | x : Item in i.itemSet.items where x != it];
    return i;
  }
  
  define output (t:TestEnt){
    "Test:" 
    for(i:Item in t.itemSet.items){
      output(i.name)
    }
  }
  
  define output (l : Set<Item>){
    "Set<Item>:" 
    for(i:Item in l){
      output(i.name)
    }
  }
