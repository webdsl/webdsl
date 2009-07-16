//Property test for Entity User is defined multiple times.

application test

  entity SuperUser {}

  entity User : SuperUser{
    test :: String (id) := "fsdjdskjf"  //nonsense derived property with annos
  }
  
  extend entity User{
    test :: Int
  }