//Property 'test' of entity 'User' is defined multiple times.

application test

  entity SuperUser {
  }

  entity User : SuperUser {
    test :: Int
  }
  
  extend entity User{
  }
  
  extend entity SuperUser {
    test :: String
    
  }