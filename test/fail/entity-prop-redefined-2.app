//Property 'name' of entity 'User' is defined multiple times.

application test

  entity User{
    test :: String
  }
  
  extend entity User{
    name :: Int := 0
  }
  
  extend entity User{
    name :: Int
  }