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
  }

  define page root() {

    var d : SuperClass := SubClass()

    output(d.getProp())


    var s : SubClass := SubClass()
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
