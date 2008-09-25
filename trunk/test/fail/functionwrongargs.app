// No function or page getA with this signature

application test

section datamodel

globals {
  function getA(i : Int) : String {
    return "a";
  }
  
  function useA() {
    getA("Fiets");
  }
}
