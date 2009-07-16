//Property name for Session Entity user is defined multiple times.

application test

  session user{
    name :: String
  }
  
  extend session user{
    name :: Int
  }
