application bla

  entity Foo{
    t :: String

    invList -> List<Foo> (inverse=Foo.backList)
    backList -> Foo
    extend function addToInvList(s: Foo){
      t := "1";
    }
    extend function removeFromInvList(s: Foo){
      t := "2";
    }

    list -> List<Foo>
    extend function addToList(s: Foo){
      t := "3";
    }
    extend function removeFromList(s: Foo){
      t := "4";
    }

    
    invSet -> Set<Foo> (inverse=Foo.backSet)
    backSet -> Foo
    extend function addToInvSet(s: Foo){
      t := "5";
    }
    extend function removeFromInvSet(s: Foo){
      t := "6";
    }

    set -> Set<Foo>
    extend function addToSet(s: Foo){
      t := "7";
    }
    extend function removeFromSet(s: Foo){
      t := "8";
    }

  }
  
  var gfoo := Foo{}
  
  test bla{
    var f := Foo{};

    // Inverse list
    addGFooList(f.invList);
    assert(f.t=="1");
    assert(f.invList.length==1);
    assert(gfoo.backList==f);
    removeGFooList(f.invList);
    assert(f.t=="2");
    assert(f.invList.length==0);
    assert(gfoo.backList==null);

    // List without inverse
    addGFooList(f.list);
    assert(f.t=="3");
    assert(f.list.length==1);
    removeGFooList(f.list);
    assert(f.t=="4");
    assert(f.list.length==0);

    // Inverse set
    addGFooSet(f.invSet);
    assert(f.t=="5");
    assert(f.invSet.length==1);
    assert(gfoo.backSet==f);
    removeGFooSet(f.invSet);
    assert(f.t=="6");
    assert(f.invSet.length==0);
    assert(gfoo.backSet==null);

    // Set without inverse
    addGFooSet(f.set);
    assert(f.t=="7");
    assert(f.set.length==1);
    removeGFooSet(f.set);
    assert(f.t=="8");
    assert(f.set.length==0);
  }
  
  function addGFooList(l:List<Foo>){
    l.add(gfoo);
  }
  
  predicate removeGFooList(l:List<Foo>){
    removeGFooListHelper(l)
  }
  
  function removeGFooListHelper(l1:List<Foo>):Bool{
    l1.remove(gfoo);
    return true;
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
  
  define page root(){}