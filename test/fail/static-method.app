//function getA has no return type but tries to return a variable
//Return statement missing in function
//No function 'getA' for 'TestEntity2' with signature getA(String)
// The return statement in function f should have type String

application test

entity TestEntity1 {
  static function getA(i : Int) {
    return "a";
  }
}


entity TestEntity2 {
  static function get(i : Int) : Int { }

  static function getA(i : Int) : String {
    return "a";
  }
  
  static function useA() {
    TestEntity2.getA("Foo");
  }
}


entity TestEntity3 {
  static function f(i : Int) : String {
    return i * i;
  }
}
