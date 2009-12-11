//Cannot find action with signature
application test

  define page root(){
    action tst(){}
  
    block[onclick := test()]{"bla"}
  }