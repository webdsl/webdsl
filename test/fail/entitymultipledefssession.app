//is defined multiple times

application test

  
  session user{
    name :: String
  }
  
  session user{
    name :: String
    password :: Secret
  }

