application ifexpr

  define page root(){}
  
  test ifexpr{
    assert((if(true)"1"else"2")=="1");
    assert("2"==(if(false)"1"else"2"));
  }