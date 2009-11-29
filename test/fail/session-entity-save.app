//No function

application test

  session user{
    test :: Int
    
    function bla(){
      save();
      delete();
    }
  }

  define page root(){}