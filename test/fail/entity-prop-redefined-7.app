//Property test for Entity User is defined multiple times.

application test

  entity SuperUser {
  }

  entity User : SuperUser {
  }
  
  extend entity User{
    test :: Int
  }
  
  extend entity SuperUser {
    test :: String
    
  }