application nativeclass

  native class nativejava.TestSub as SubClass : SuperClass {
    prop :String
    getProp():String
    setProp(String)
    constructor()
  }

  native class  nativejava.TestSuper as SuperClass  {
    getProp():String
    static getStatic(): String
    returnList(): List<SubClass>
    returnList2(): [SubClass]
    returnSet(): Set<SubClass>
    returnSet2(): {SubClass}
  }

  page root() {

    var d : SuperClass := SubClass()

    output(d.getProp())


    var s : SubClass := SubClass()
    var q : Bool := (s is a SuperClass)
    init{
      s.setProp("test");
    }
    output(s.prop)


    output(SuperClass.getStatic())
    output(SubClass.getStatic())

    for(a: SubClass in d.returnList()){
      output(a.prop)
    }

  }

  test{
    var d : SuperClass := SubClass();
    assert(d.getProp() == null);
    
    var s : SubClass := SubClass();
    assert(s is a SuperClass);
    
    s.setProp("test");
    assert(s.prop == "test");

    assert(SuperClass.getStatic() == "static");
    assert(SubClass.getStatic() == "static");

    for(a: SubClass in d.returnList()){
      assert(a.prop == "esfsfsf");
    }
    
    assert(d.returnList2().length == 0);
    assert(d.returnSet().length == 0);
    assert(d.returnSet2().length == 0);

  }