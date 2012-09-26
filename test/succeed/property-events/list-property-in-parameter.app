application bla

  entity Foo{
    name :: String
    log :: String

    invList -> List<Foo> (inverse=Foo.backList)
    backList -> Foo
    extend function addToInvList(s: Foo){
      log := log + "+il:" + s.name;
    }
    extend function removeFromInvList(s: Foo){
      log := log + "-il:" + s.name;
    }

    list -> List<Foo>
    extend function addToList(s: Foo){
      log := log + "+l";
    }
    extend function removeFromList(s: Foo){
      log := log + "-l";
    }

    
    invSet -> Set<Foo> (inverse=Foo.backSet)
    backSet -> Foo
    extend function addToInvSet(s: Foo){
      log := log + "+is";
    }
    extend function removeFromInvSet(s: Foo){
      log := log + "-is";
    }

    set -> Set<Foo>
    extend function addToSet(s: Foo){
      log := log + "+s";
    }
    extend function removeFromSet(s: Foo){
      log := log + "-s";
    }

    invManySet -> Set<Foo> (inverse=Foo.manySet)
    extend function addToInvManySet(s: Foo){
      log := log + "+ims";
    }
    extend function removeFromInvManySet(s: Foo){
      log := log + "-ims";
    }
    manySet -> Set<Foo>
    extend function addToManySet(s: Foo){
      log := log + "+ms";
    }
    extend function removeFromManySet(s: Foo){
      log := log + "-ms";
    }

  }
  
  var gfoo := Foo{ name := "gfoo" }
  var gfoo2 := Foo{ name := "gfoo2" }
  var gfoo3 := Foo{ name := "gfoo3" }
  
  test bla{
    var f := Foo{ name := "f" };

    // Inverse list
    f.log := "";
    addGFooList(f.invList);
    assert(f.log=="+il:gfoo");
    assert(f.invList.length==1);
    assert(gfoo.backList==f);
    removeGFooList(f.invList);
    assert(f.log=="+il:gfoo-il:gfoo");
    assert(f.invList.length==0);
    assert(gfoo.backList==null);

    // List without inverse
    f.log := "";
    addGFooList(f.list);
    assert(f.log=="+l");
    assert(f.list.length==1);
    removeGFooList(f.list);
    assert(f.log=="+l-l");
    assert(f.list.length==0);

    // Inverse set
    f.log := "";
    addGFooSet(f.invSet);
    assert(f.log=="+is");
    assert(f.invSet.length==1);
    assert(gfoo.backSet==f);
    removeGFooSet(f.invSet);
    assert(f.log=="+is-is");
    assert(f.invSet.length==0);
    assert(gfoo.backSet==null);

    // Set without inverse
    f.log := "";
    addGFooSet(f.set);
    assert(f.log=="+s");
    assert(f.set.length==1);
    removeGFooSet(f.set);
    assert(f.log=="+s-s");
    assert(f.set.length==0);

    // Many to many set
    f.log := "";
    addGFooSet(f.invManySet);
    assert(f.log=="+ims");
    assert(f.invManySet.length==1);
    assert(gfoo.log=="+ms");
    assert(gfoo.manySet.length==1);
    removeGFooSet(f.invManySet);
    assert(f.log=="+ims-ims");
    assert(f.invManySet.length==0);
    assert(gfoo.log=="+ms-ms");
    assert(gfoo.manySet.length==0);
    addGFooSet(f.manySet);
    assert(f.log=="+ims-ims+ms");
    assert(f.manySet.length==1);
    assert(gfoo.log=="+ms-ms+ims");
    assert(gfoo.invManySet.length==1);
    removeGFooSet(f.manySet);
    assert(f.log=="+ims-ims+ms-ms");
    assert(f.manySet.length==0);
    assert(gfoo.log=="+ms-ms+ims-ims");
    assert(gfoo.invManySet.length==0);

    // List functions (insert, removeAt, set)
    f.log := "";
    f.invList.add(f);
    insertIntoList(f.invList, 0, gfoo);
    insertIntoList(f.invList, 1, gfoo2);
    assert(f.backList==f);
    assert(gfoo.backList==f);
    assert(gfoo2.backList==f);
    assert(f.log=="+il:f+il:gfoo+il:gfoo2");
    assert(f.invList.length==3);
    assertList(f.invList, "gfoo,gfoo2,f,");
    setInList(f.invList, 2, gfoo3);
    assert(f.backList==null);
    assert(gfoo3.backList==f);
    assert(f.log=="+il:f+il:gfoo+il:gfoo2-il:f+il:gfoo3");
    assert(f.invList.length==3);
    assertList(f.invList, "gfoo,gfoo2,gfoo3,");
    removeAtList(f.invList, 1);
    assert(gfoo2.backList==null);
    assert(f.log=="+il:f+il:gfoo+il:gfoo2-il:f+il:gfoo3-il:gfoo2");
    assert(f.invList.length==2);
    assertList(f.invList, "gfoo,gfoo3,");
    
    // Other functions (addAll, clear)
    f.invList.clear();
    f.log := "";
    addAllGFoosList(f.invList);
    assert(f.log=="+il:gfoo+il:gfoo2+il:gfoo3");
    assert(f.invList.length==3);
    assert(gfoo.backList==f);
    assert(gfoo2.backList==f);
    assert(gfoo3.backList==f);
    removeAllFromList(f.invList);
    assert(f.log=="+il:gfoo+il:gfoo2+il:gfoo3-il:gfoo-il:gfoo2-il:gfoo3");
    assert(f.invList.length==0);
    assert(gfoo.backList==null);
    assert(gfoo2.backList==null);
    assert(gfoo3.backList==null);
  }

  function insertIntoList(l:List<Foo>, i:Int, f:Foo){
    l.insert(i, f);
  }
  
  function removeAtList(l:List<Foo>, i:Int){
    l.removeAt(i);
  }
  
  function setInList(l:List<Foo>, i:Int, f:Foo){
    l.set(i, f);
  }
  
  function addGFooList(l:List<Foo>){
    l.add(gfoo);
  }
  
  function addAllGFoosList(l:List<Foo>){
    l.addAll([gfoo, gfoo2, gfoo3]);
  }
  
  predicate removeGFooList(l:List<Foo>){
    removeGFooListHelper(l)
  }
  
  function removeGFooListHelper(l1:List<Foo>):Bool{
    l1.remove(gfoo);
    return true;
  }
  
  function removeAllFromList(l:List<Foo>){
    l.clear();
  }
  
  function addGFooSet(s:Set<Foo>){
    s.add(gfoo);
  }
  
  predicate removeGFooSet(s:Set<Foo>){
    removeGFooSetHelper(s)
  }
  
  function removeGFooSetHelper(s1:Set<Foo>):Bool{
    s1.remove(gfoo);
    return true;
  }

  function assertList(l:List<Foo>,s:String){
    var conc : String := "";
    for(f : Foo in l) {
      conc := conc + f.name + ",";
    }
    assert(conc==s);
  }
  
  define page root(){}