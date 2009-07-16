//Property test for Session Entity user is defined multiple times.

application test

  session user{
  }
  
  extend session user{
    test :: Int
  }
  
  extend session user{
    test :: Int
  }