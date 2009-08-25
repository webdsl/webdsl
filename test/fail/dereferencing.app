//No property about defined for Person
application test

  entity User{
    person -> Person
  }
  entity Person{
    abot :: Text
  }
  
  var user := User {}

  define page red(){"redirected"}

  define page root()
  {
    if(user.person.about.length() < 200) { }
  }
