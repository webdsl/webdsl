//Property 'test' of entity 'User' is defined multiple times

application test

  entity SuperUser {
    test :: String
  }

  entity User : SuperUser {
    test :: Int
  }
  
  extend entity User{
  }