//should be of collection type
application test

  entity SomeEntity {
    property :: String
    ref -> SomeEntity
    refs -> List<AnotherEntity>
  
  }
  
  entity AnotherEntity {
    bla :: String
  }
  
  var e:= SomeEntity{};
  var e1:= SomeEntity{};
  var e2:= SomeEntity{};
  var e3:= SomeEntity{};
  

  define page invalid() {
    form{
      select(e.ref from e3)
    }
  }