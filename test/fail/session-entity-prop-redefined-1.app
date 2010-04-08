//Property 'name' of entity 'User' is defined multiple times.

application test

  session user{
    name :: String
  }
  
  extend session user{
    name :: Int
  }
