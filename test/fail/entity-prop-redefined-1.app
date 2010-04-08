//Property 'name' of entity 'User' is defined multiple times.

application test

  entity User{
    name :: String (id)
  }
  
  extend entity User{
    name :: Int
  }
