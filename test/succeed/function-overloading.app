application functionoverloading

define page root() {}

entity Base {}
entity Extend : Base { prop :: String }

// WebDSL/143
function f(e : Extend) : Extend { return null; }
function f(e : Base) : Base { return null; }

function g() {
  
  var x : Extend;
  f(x).prop := "x";   // should resolve to f(Extend) : Extend
  
}

// --------------

entity TestEntityOverload {
  
  function f1(e : Extend) : Extend { return null; }
  function f1(e : Base) : Base { return null; }
  
  // WebDSL/143
  function g1() {
    
    var x : Extend;
    f1(x).prop := "x";
    
  }
  
  // WebDSL/144 (java compilation error)
  function h(e : Base) {
    var x : Extend;
    h(x);
  }
  
  function h() {}
  
}
