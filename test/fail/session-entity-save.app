//No function or page 'save' with signature

application test

  session user{
    test :: Int
    
    function bla(){
      save();
      delete();
    }
  }

  define page root(){}