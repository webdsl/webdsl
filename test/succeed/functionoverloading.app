application test

section datamodel

  entity AnEntity {
    function a(arg : Int) : Int {
      return arg + 1;
    }

    function a(arg : String) : String {
      return ", " + arg;
    }
  }

  function a(s : String) : String {
    return s + "?";
  }

  function a(s : WikiText) : String {
    return "Whatever dude";
  }

  
  function a(o : Object) : String {
    return "none";
  }
  
  function a(s:WikiText,s1:WikiText) : String {
    return "none";
  }
  
  function a(s : WikiText,o :Object) : String {
    return "Whatever dude";
  }

  function f(s : String) : String {
    return s;
  }

  var an : AnEntity := AnEntity {};
  
  define page root(){
    output(an.a(0))
    output(an.a("2"))
    output(a("Really"))
    output(a("Really" as WikiText))
    //output(a(67))
    output(a("Really" as WikiText,"Really" as WikiText))
  }


