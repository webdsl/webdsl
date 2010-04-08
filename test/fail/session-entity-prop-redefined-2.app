//Property 'test' of entity 'User' is defined multiple times.

application test

  session user{
  }
  
  extend session user{
    test :: Int
  }
  
  extend session user{
    test :: Int
  }