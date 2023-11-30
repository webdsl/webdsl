//Function with signature test(Int, String) of entity 'User' is defined multiple times
application test

entity User {
  name : String
}

extend entity User {
  function test( a: Int, b: String ): String {
    return "test";
  }
}

extend entity User {
  function test( a: Int, b: String ): String {
    return "test";
  }
}

page root {
  var u := User{}
  ~u.name
}
